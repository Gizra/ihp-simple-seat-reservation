module Web.View.Venues.Show where
import Web.View.Prelude

data ShowView = ShowView
    { venue :: Venue
    , events :: [Event]
    }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>Venue: {get #title venue}</h1>

        {renderEvents venue events}

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink homeIcon VenuesAction
                            , breadcrumbText $ cs (get #title venue)
                            ]

renderEvents venue events =
    if null events
        then [hsx|
            <div>
                No Events added to this venue yet.
                {newButton}
            </div>
        |]
        else [hsx|
                <h2>Events</h2>
                {newButton}


                <table class="table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Title</th>
                            <th>Start Time</th>
                            <th>End Time</th>
                        </tr>
                    </thead>
                    <tbody>
                        {forEachWithIndex events (renderEvent (length events))}
                    </tbody>
                </table>
            |]
    where
        newButton = [hsx|
                <div>
                    <a href={pathTo $ NewEventAction (get #id venue) } class="btn btn-primary">+ Add Event</a>
                </div>
        |]

renderEvent totalEvents (index, event) = [hsx|
        <tr>
            <td>{index + 1}</td>
            <td><a class="text-blue-500 hover:text-blue-600 hover:underline" href={ShowEventAction (get #id event)}>{get #title event}</a></td>
            <td>{get #startTime event |> dateTime}</td>
            <td>{get #endTime event |> dateTime}</td>
        </tr>


    |]