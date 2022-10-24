module Web.View.Reservations.Helper (renderReservationsCard) where

import Web.View.Prelude

{-| Render a single reservation. First argument is the total reservation, and the index of current reservation.-}
renderReservationsCard :: Maybe (Int, Int)->  Reservation -> Html
renderReservationsCard maybeTotalReservationsAndIndex reservation = [hsx|
        <div class="border border-gray-300 px-6 py-4 rounded hover:bg-gray-100 flex flex-col space-y-4">

            <div class="flex flex-row justify-between items-center">

                <div class="flex flex-row space-x-2">
                    <!-- https://heroicons.com/: identification -->
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H5a2 2 0 00-2 2v9a2 2 0 002 2h14a2 2 0 002-2V8a2 2 0 00-2-2h-5m-4 0V5a2 2 0 114 0v1m-4 0a2 2 0 104 0m-5 8a2 2 0 100-4 2 2 0 000 4zm0 0c1.306 0 2.417.835 2.83 2M9 14a3.001 3.001 0 00-2.83 2M15 11h3m-3 4h2" />
                    </svg>
                    <div class="text-gray-700">
                        {reservation.personIdentifier}
                    </div>

                </div>

                {reservationNumber}
            </div>



            <div class="flex flex-row justify-between items-end">
                <div>{seatContent}</div>
                <div class="text-red-500 hover:text-red-600 text-sm hover:underline"><a href={DeleteReservationAction reservation.id} class="js-delete text-muted">Delete</a></div>
            </div>

        </div>

    |]
    where
        -- Show the reservation number if exists, other nothing
        reservationNumber =
            case maybeTotalReservationsAndIndex of
             Just (totalReservations, index) -> [hsx|
                <a class="text-sm text-gray-400 hover:text-gray-500 hover:underline" href={pathTo (ShowReservationAction reservation.id)}>#{totalReservations - index}</a>
                |]
             Nothing -> mempty

        seatContent =
                case reservation.status of
                    Queued -> [hsx|
                        <div class="flex flex-row space-x-2 items-end">
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
                        <div class="flex flex-row space-x-2 items-end">
                            <!-- https://heroicons.com/: check-circle -->
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-green-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>

                            <div class="text-gray-900">
                                Seat {reservation.seatNumber}
                            </div>

                        </div>


                    |]
                    Rejected -> [hsx|
                        <div class="flex flex-row space-x-2 items-end">
                            <!-- https://heroicons.com/: x-circle -->
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-red-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>

                            <div class="text-gray-500">
                                No seat
                            </div>

                        </div>
                    |]

