module Web.Controller.Reservations where

import Web.Controller.Prelude
import Web.View.Reservations.New
import Web.View.Reservations.Show
import Web.Mail.Reservations.Confirmation
import Data.Either (isLeft)
import Data.Text (length)
import Data.Char (isDigit)
import Data.Foldable (any)

instance Controller ReservationsController where

    action NewReservationAction {..} = do
        let reservation = newRecord |> set #eventId eventId
        event <- fetch eventId
        venue <- fetch event.venueId
        render NewView { .. }

    action ShowReservationAction { reservationId } = do
        reservation <- fetch reservationId
        event <- fetch reservation.eventId
        venue <- fetch event.venueId
        render ShowView { .. }

    action CreateReservationAction = do
        let reservation = newRecord @Reservation
        reservation
            |> buildReservation
            |> validatePersonIdentifier
            |> ifValid \case
                Left reservation -> do
                    event <- fetch reservation.eventId
                    venue <- fetch event.venueId
                    render NewView { .. }
                Right reservation -> do
                    reservation <- reservation
                        |> set #status Queued
                        |> createRecord

                    -- Create a Job for the Reservation to be processed.
                    newRecord @ReservationJob
                        |> set #reservationId reservation.id
                        |> create

                    setSuccessMessage "Reservation request registered"
                    redirectTo $ ShowEventAction reservation.eventId

    action DeleteReservationAction { reservationId } = do
        reservation <- fetch reservationId
        deleteRecord reservation
        setSuccessMessage "Reservation deleted"
        redirectTo $ ShowEventAction reservation.eventId

buildReservation reservation = reservation
    |> fill @["eventId","seatNumber","personIdentifier", "delay"]

validatePersonIdentifier reservation =
    if isLeft (personIdentifierResult $ reservation.personIdentifier)
        then reservation |> attachFailure #personIdentifier "Person ID is not valid"
        else reservation



{-| Error messages are handy for debugging and testing. The user should not see them.
-}
personIdentifierResult :: Text -> Either Text ()
personIdentifierResult val =
    let
        rightVal = Right ()
    in
    rightVal
        >>= (\_ ->  if "0000" `isPrefixOf` val then Left "Prefix of 0000 is not allowed" else rightVal)
        >>= (\_ -> if Data.Text.length val < 3 then Left "ID shorter than 3" else rightVal)
        >>= (\_ -> if Data.Foldable.any (not . isDigit) (cs val::String) then Left "ID should only be consisted of digits" else rightVal)