module Web.View.Reservations.Show where
import Web.View.Prelude

data ShowView = ShowView
    { reservation :: Reservation
    , event :: Event
    }

instance View ShowView where
    html ShowView { .. } = [hsx|
        <h1>Show Reservation</h1>
        <p>{reservation}</p>
    |]
