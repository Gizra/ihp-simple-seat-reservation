module Web.View.Events.Show where
import Web.View.Prelude

data ShowView = ShowView
    { event :: Event
    , venue :: Venue
    , reservations :: [ Reservation ]
    }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>Reservation for {get #title event} Event</h1>

        <div class="mb-4 mt-4">Time slot: {get #startTime event |> dateTime} - {get #endTime event |> dateTime}</div>
        <div class="mb-4 "><strong>{acceptedReservations}</strong> out of <strong>{get #totalNumberOfSeats venue}</strong> total seats</div>

        {renderReservations event reservations}
    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Venues" $ VenuesAction
                            , breadcrumbLink "Events" $ ShowVenueAction (get #venueId event)
                            , breadcrumbText "Show Event"
                            ]

            acceptedReservations =
                reservations
                    |> filter (\reservation -> get #status reservation == Accepted)
                    |> length


renderReservations event reservations =
    [hsx|
        <div>
            <a href={pathTo $ NewReservationAction (get #id event) } class="btn btn-primary mb-4">+ New Reservation</a>
        </div>

        {content}
    |]
    where
        content =
            if null reservations
                then [hsx|No Reservations|]
                else renderReservationsTable event reservations


renderReservationsTable event reservations = [hsx|
        <table class="table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Seat number</th>
                    <th>Person ID</th>
                    <th>Status</th>
                    <th>Ops</th>
                </tr>
            </thead>
            <tbody>
                {forEachWithIndex reservations (renderReservation totalReservations)}
            </tbody>
        </table>
    |]
        where totalReservations = length reservations


renderReservation totalReservations (index, reservation) = [hsx|
        <tr>
            <td>{totalReservations - index}</td>
            <td>{seatContent}</td>
            <td>{get #personIdentifier reservation}</td>
            <td>{get #status reservation}</td>
            <td><a href={DeleteReservationAction (get #id reservation)} class="js-delete text-muted">Delete</a></td>
        </tr>

    |]
    where seatContent =
                case get #status reservation of
                    Queued -> [hsx|Waiting for seat...|]
                    Accepted -> [hsx|Seat {get #seatNumber reservation}|]
                    Rejected -> [hsx|No seat|]
