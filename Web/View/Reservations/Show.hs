module Web.View.Reservations.Show where
import Web.View.Prelude
import Web.View.Reservations.Helper (renderReservationsCard)

data ShowView = ShowView
    { reservation :: Reservation
    , event :: Event
    , venue :: Venue
    }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>Reservation Details</h1>

        <div class="mt-8">
            {renderReservationsCard Nothing reservation}
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink homeIcon VenuesAction
                , breadcrumbLink (cs (get #title venue)) $ ShowVenueAction event.venueId
                , breadcrumbLink (cs (get #title event)) $ ShowEventAction event.id
                , breadcrumbText "Reservation Details"
                ]
