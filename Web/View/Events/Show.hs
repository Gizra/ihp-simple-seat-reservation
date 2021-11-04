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

        <div class="border border-yellow-200 bg-yellow-50 text-yellow-800 rounded p-4 my-6 flex flex-row space-x-2 items-start">
            <svg xmlns="http://www.w3.org/2000/svg" class="mt-1 h-5 w-5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <p>
                This area is meant for the event organizer to view the reservations.
                But we are also going to use it for the attendees to register to the event.
            </p>
        </div>

        <h1 class="text-3xl">Reservations for {get #title event} Event</h1>

        <div class="flex flex-col space-y-2 sm:flex-row justify-between mt-6 mb-8 items-baseline">

            <div><strong>{acceptedReservations}</strong> out of <strong>{get #totalNumberOfSeats venue}</strong> total seats</div>

            <div class="flex flex-row space-x-4 text-gray-500 text-sm">
                <div>{get #startTime event |> dateTime}</div>
                <span>—</span>
                <div>{get #endTime event |> dateTime}</div>
            </div>
        </div>




        {renderReservations event reservations}

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Home" $ VenuesAction
                            , breadcrumbLink (cs (get #title venue)) $ ShowVenueAction (get #venueId event)
                            , breadcrumbText $ cs (get #title event)
                            ]

            acceptedReservations =
                reservations
                    |> filter (\reservation -> get #status reservation == Accepted)
                    |> length


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
                    {forEach reservations (renderReservationsCard totalReservations)}
                    </div>
                |]
                        where totalReservations = length reservations



renderReservationsCard totalReservations reservation = [hsx|
        <div class="border border-gray-300 px-6 py-4 rounded hover:bg-gray-100 flex flex-col space-y-4">
            <div class="flex flex-row space-x-2">
                <!-- https://heroicons.com/: identification -->
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H5a2 2 0 00-2 2v9a2 2 0 002 2h14a2 2 0 002-2V8a2 2 0 00-2-2h-5m-4 0V5a2 2 0 114 0v1m-4 0a2 2 0 104 0m-5 8a2 2 0 100-4 2 2 0 000 4zm0 0c1.306 0 2.417.835 2.83 2M9 14a3.001 3.001 0 00-2.83 2M15 11h3m-3 4h2" />
                </svg>
                <div class="text-gray-700">
                    {get #personIdentifier reservation}
                </div>

            </div>


            <div class="flex flex-row justify-between">
                <div>{seatContent}</div>
                <div class="text-red-500 hover:text-red-600 text-sm hover:underline"><a href={DeleteReservationAction (get #id reservation)} class="js-delete text-muted">Delete</a></div>
            </div>

        </div>

    |]
    where seatContent =
                case get #status reservation of
                    Queued -> [hsx|
                        <div class="flex flex-row space-x-2">
                            <!-- https://heroicons.com/: clock -->
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>

                            <div class="italic">
                                Waiting for seat...
                            </div>
                        </div>
                    |]
                    Accepted -> [hsx|
                        <div class="flex flex-row space-x-2">
                            <!-- https://heroicons.com/: check-circle -->
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-green-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>

                            <div class="text-gray-900">
                                Seat{get #seatNumber reservation}
                            </div>

                        </div>


                    |]
                    Rejected -> [hsx|
                        <div class="flex flex-row space-x-2">
                         <!-- https://heroicons.com/: x-circle -->
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-red-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>

                        <div class="text-gray-500">
                            No seat
                        </div>

                        </div>
                    |]
