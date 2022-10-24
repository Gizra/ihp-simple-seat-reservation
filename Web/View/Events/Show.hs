module Web.View.Events.Show where
import Web.View.Prelude
import Web.View.Reservations.Helper (renderReservationsCard)
import Data.Text (replace)

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
                    1) You can test how twenty concurrent requests would look using <code>parallel</code>

                    <div class="copy-paste flex flex-row items-center">
                        <input class="rounded-l border-yellow-500 text-gray-500 w-4/5" type="text" value={copyPasteCode} readonly />
                        <button class="rounded-r border-r border-t border-b border-yellow-500 hover:bg-yellow-200">
                            <!-- https://heroicons.com : duplicate -->
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <title>Copy code</title>
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                            </svg>
                        </button>

                    </div>
                </p>

                <p>
                    2) You can view the sent HTML emails by opening Mailhog. {mailhogHelp baseUrl}
                </p>
            </div>
        </div>

        <h1>Reservations for {event.title} Event</h1>

        <div class="flex flex-col space-y-2 sm:flex-row justify-between mt-6 mb-8 items-baseline">

            <div><strong>{acceptedReservations}</strong> out of <strong>{venue.totalNumberOfSeats }</strong> total seats</div>

            <div class="flex flex-row space-x-2 text-gray-500 text-sm">
                <div>{event.startTime  |> dateTime}</div>
                <span>—</span>
                <div>{event.endTime |> dateTime}</div>
            </div>
        </div>

        {renderReservations event reservations}

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink homeIcon $ VenuesAction
                            , breadcrumbLink (cs venue.title) $ ShowVenueAction event.venueId
                            , breadcrumbText $ cs event.title
                            ]

            acceptedReservations =
                reservations
                    |> filter (\reservation -> get #status reservation == Accepted)
                    |> length

            baseUrl = ?context.frameworkConfig.baseUrl

            eventId = show $ event.id :: Text

            copyPasteCode = "time seq 20 | parallel -n0 \"curl '" ++ baseUrl ++ "/CreateReservation' -H 'content-type: application/x-www-form-urlencoded' --data-raw 'eventId=" ++ eventId ++ "&personIdentifier=1234' --compressed\"" :: Text


mailhogHelp :: Text -> Html
mailhogHelp baseUrl
    | "http://localhost" `isInfixOf` baseUrl = [hsx|We think you run this instance locally, so you would need to manually install and run Mailhog, and then you can access it via <a class="underline" href="http://0.0.0.0:8025" target="_blank">http://0.0.0.0:8025</a>.|]
    | "https://8000-" `isInfixOf` baseUrl= mailhogGitpod $ replace "https://8000-" "https://8025-" baseUrl
    | otherwise = [hsx|We couldn't detect if you are running this instance locally or on GitPod.io, so we don't know where Mailhog is running.|]
    where
        mailhogGitpod url = [hsx| We think you run this instance on Gitpod.io, so you can access Mailhog via <a class="underline" href={url} target="_blank">{url}</a>|]


renderReservations event reservations =
    [hsx|
        <div>
            <a href={pathTo $ NewReservationAction event.id } class="inline-block btn btn-primary mb-4">New Reservation</a>
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

