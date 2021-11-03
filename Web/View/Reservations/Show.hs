module Web.View.Reservations.Show where
import Web.View.Prelude

data ShowView = ShowView
    { reservation :: Reservation
    , event :: Event
    }

instance View ShowView where
    html ShowView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={ReservationsAction (get #id event)}>Reservations</a></li>
                <li class="breadcrumb-item active">Show Reservation</li>
            </ol>
        </nav>
        <h1>Show Reservation</h1>
        <p>{reservation}</p>
    |]
