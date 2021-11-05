module Web.View.Reservations.Show where
import Web.View.Prelude

data ShowView = ShowView
    { reservation :: Reservation
    , event :: Event
    }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1 class="text-3xl">Reservation Details</h1>
        <div>#{get #personIdentifier reservation}</div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink homeIcon VenuesAction
                , breadcrumbLink (cs (get #title event)) $ ShowEventAction (get #id event)
                , breadcrumbText "Reservation Details"
                ]
