module Web.View.Events.Show where
import Web.View.Prelude
import Web.View.Reservations.Helper (renderReservationsCard)

data ShowView = ShowView
    { event :: Event
    , venue :: Venue
    , reservations :: [ Reservation ]
    }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}

        <div class="border border-yellow-200 bg-yellow-50 text-yellow-800 rounded p-4 my-6 flex flex-row space-x-2 items-start">
            <svg xmlns="http://www.w3.org/2000/svg" class="mt-1 h-5 w-5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <div class="flex flex-col space-y-6">
                <p>
                    This area is meant for the event organizer to view the reservations.
                    But we are also going to use it for the attendees to register to the event.
                </p>
                <p>
                    You can test how twenty concurrent requests would look using <code>parallel</code>

                    <div class="copy-paste flex flex-row items-center">
                        <input class="rounded-l border-yellow-500 text-gray-500 w-4/5" type="text" value={copyPasteCode} readonly />
                        <button class="rounded-r border-r border-t border-b border-yellow-500 hover:bg-yellow-200">
                            <!-- https://heroicons.com : duplicate -->
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                            </svg>
                        </button>

                    </div>
                </p>
            </div>
        </div>

        <h1 class="text-3xl">Reservations for {get #title event} Event</h1>

        <div class="flex flex-col space-y-2 sm:flex-row justify-between mt-6 mb-8 items-baseline">

            <div><strong>{acceptedReservations}</strong> out of <strong>{get #totalNumberOfSeats venue}</strong> total seats</div>

            <div class="flex flex-row space-x-2 text-gray-500 text-sm">
                <div>{get #startTime event |> dateTime}</div>
                <span>—</span>
                <div>{get #endTime event |> dateTime}</div>
            </div>
        </div>




        {renderReservations event reservations}

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink homeIcon $ VenuesAction
                            , breadcrumbLink (cs (get #title venue)) $ ShowVenueAction (get #venueId event)
                            , breadcrumbText $ cs (get #title event)
                            ]

            acceptedReservations =
                reservations
                    |> filter (\reservation -> get #status reservation == Accepted)
                    |> length

            baseUrl = getConfig |> get #baseUrl

            eventId = show $ get #id event :: Text

            copyPasteCode = "time seq 20 | parallel -n0 \"curl '" ++ baseUrl ++ "/CreateReservation' -H 'content-type: application/x-www-form-urlencoded' --data-raw 'eventId=" ++ eventId ++ "&personIdentifier=1234' --compressed\"" :: Text


renderReservations event reservations =
    [hsx|
        <div>
            <a href={pathTo $ NewReservationAction (get #id event) } class="inline-block btn btn-primary mb-4">New Reservation</a>
        </div>

        {content}
    |]
    where
        content =
            if null reservations
                then [hsx|
                    <div class="text-gray-500">
                        No reservations yet...
                    </div>
                |]
                else [hsx|
                    <div class="flex flex-col space-y-2">
                        {forEachWithIndex reservations (\(index, reservation) -> renderReservationsCard (Just (totalReservations, index)) reservation)}
                    </div>
                |]
                        where totalReservations = length reservations

