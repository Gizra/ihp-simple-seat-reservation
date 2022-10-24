module Web.Mail.Reservations.Confirmation where

import Web.View.Prelude
import IHP.MailPrelude

data ConfirmationMail = ConfirmationMail
    { reservation :: Reservation
    , venue :: Venue
    }

instance BuildMail ConfirmationMail where
    subject = status |> \case
            Accepted -> "Reservation Accepted (Seat " ++ show (reservation.seatNumber) ++ ")"
            Rejected -> "Reservation Rejected"
            _ -> ""
        where
            reservation = get #reservation ?mail
            status = reservation.status

    to ConfirmationMail { .. } = Address { addressName = Just "Firstname Lastname", addressEmail = "fname.lname@example.com" }
    from = "hi@example.com"
    html ConfirmationMail { .. } = [hsx|
        Hello Person (#{reservation.personIdentifier}),

        <p>
            Your reservation for venue "{venue.title}" is now <strong>{reservation.status}</strong>
            See <a href={urlTo $ ShowReservationAction reservation.id}>Reservation</a>
        </p>
    |]
