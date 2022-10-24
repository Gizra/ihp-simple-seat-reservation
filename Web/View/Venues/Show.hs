module Web.View.Venues.Show where
import Web.View.Prelude

data ShowView = ShowView
    { venue :: Venue
    , events :: [Event]
    }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}

        <div class="flex flex-col space-y-6 mb-12">
            <h1>{get #title venue}'s Events</h1>

            <div>
                <a href={pathTo $ NewEventAction venue.id } class="btn btn-primary">+ Add Event</a>
            </div>
        </div>

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
            <div class="text-gray-500">
                No Events added to this venue yet.
            </div>
        |]
        else [hsx|
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-100">
                    <tr>
                        <th class={tableThClasses}>Title</th>
                        <th class={tableThClasses}>Start Time</th>
                        <th class={tableThClasses}>End Time</th>
                    </tr>
                </thead>
                <tbody>
                    {forEach events (renderEvent (length events))}
                </tbody>
            </table>
        |]
    where

renderEvent :: Int -> Event -> Html
renderEvent totalEvents event = [hsx|
        <tr>
            <td class={tableTdClasses}><a class={linkClass} href={ShowEventAction event.id}>{get #title event}</a></td>
            <td class={tableTdClasses}>{get #startTime event |> dateTime}</td>
            <td class={tableTdClasses}>{get #endTime event |> dateTime}</td>
        </tr>


    |]