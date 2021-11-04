module Web.Controller.Reservations where

import Web.Controller.Prelude
import Web.View.Reservations.Index
import Web.View.Reservations.New
import Web.View.Reservations.Edit
import Web.View.Reservations.Show
import Web.Mail.Reservations.Confirmation
import Data.Either (isLeft)
import Data.Text (length)
import Data.Char (isDigit)
import Data.Foldable (any)

instance Controller ReservationsController where
    action ReservationsAction {..} = do
        reservations <- query @Reservation |> fetch
        event <- fetch eventId
        render IndexView { .. }

    action NewReservationAction {..} = do
        let reservation = newRecord |> set #eventId eventId
        event <- fetch eventId
        venue <- fetch (get #venueId event)
        render NewView { .. }

    action ShowReservationAction { reservationId } = do
        reservation <- fetch reservationId
        event <- fetch (get #eventId reservation)
        render ShowView { .. }

    action EditReservationAction { reservationId } = do
        reservation <- fetch reservationId
        event <- fetch (get #eventId reservation)
        render EditView { .. }

    action UpdateReservationAction { reservationId } = do
        reservation <- fetch reservationId
        reservation
            |> buildReservation
            |> ifValid \case
                Left reservation -> do
                    event <- fetch (get #eventId reservation)
                    render EditView { .. }
                Right reservation -> do
                    reservation <- reservation |> updateRecord
                    setSuccessMessage "Reservation updated"
                    redirectTo EditReservationAction { .. }

    action CreateReservationAction = do
        let reservation = newRecord @Reservation
        reservation
            |> buildReservation
            |> validatePersonIdentifier
            |> ifValid \case
                Left reservation -> do
                    event <- fetch (get #eventId reservation)
                    venue <- fetch (get #venueId event)
                    render NewView { .. }
                Right reservation -> do
                    reservation <- reservation
                        |> set #status Queued
                        |> createRecord

                    -- Create a Job for the Reservation to be processed.
                    newRecord @ReservationJob
                        |> set #reservationId (get #id reservation)
                        |> create

                    setSuccessMessage "Reservation request registered"
                    redirectTo $ ShowEventAction (get #eventId reservation)

    action DeleteReservationAction { reservationId } = do
        reservation <- fetch reservationId
        deleteRecord reservation
        setSuccessMessage "Reservation deleted"
        redirectTo $ ShowEventAction (get #eventId reservation)

buildReservation reservation = reservation
    |> fill @["eventId","seatNumber","personIdentifier"]

validatePersonIdentifier reservation =
    if isLeft (personIdentifierResult $ get #personIdentifier reservation)
        then reservation |> attachFailure #personIdentifier "Person ID is not valid"
        else reservation



{-| Error messages are handy for debugging and testing. The user should not see them.
-}
personIdentifierResult :: Text -> Either Text Text
personIdentifierResult val =
    let
        rightVal = Right val
    in
    rightVal
        >>= (\val ->  if "0000" `isPrefixOf` val then Left "Prefix of 0000 is not allowed" else rightVal)
        >>= (\val -> if Data.Text.length val < 3 then Left "ID shorter than 3" else rightVal)
        >>= (\val -> if Data.Foldable.any (not . isDigit) (cs val::String) then Left "ID should only be consisted of digits" else rightVal)