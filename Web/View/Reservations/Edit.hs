module Web.View.Reservations.Edit where
import Web.View.Prelude

data EditView = EditView
    { reservation :: Reservation
    , event :: Event
    }

instance View EditView where
    html EditView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={ReservationsAction (get #id event)}>Reservations</a></li>
                <li class="breadcrumb-item active">Edit Reservation</li>
            </ol>
        </nav>
        <h1>Edit Reservation</h1>
        {renderForm reservation}
    |]

renderForm :: Reservation -> Html
renderForm reservation = formFor reservation [hsx|
    {(textField #eventId)}
    {(textField #seatNumber)}
    {(textField #personIdentifier)}
    {submitButton}
|]
