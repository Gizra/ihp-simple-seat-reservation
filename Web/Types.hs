module Web.Types where

import IHP.Prelude
import IHP.ModelSupport
import Generated.Types

data WebApplication = WebApplication deriving (Eq, Show)


data StaticController = WelcomeAction deriving (Eq, Show, Data)

data VenuesController
    = VenuesAction
    | NewVenueAction
    | ShowVenueAction { venueId :: !(Id Venue) }
    | CreateVenueAction
    | EditVenueAction { venueId :: !(Id Venue) }
    | UpdateVenueAction { venueId :: !(Id Venue) }
    | DeleteVenueAction { venueId :: !(Id Venue) }
    deriving (Eq, Show, Data)

data EventsController
    = EventsAction { venueId :: !(Id Venue) }
    | NewEventAction { venueId :: !(Id Venue) }
    | ShowEventAction { eventId :: !(Id Event) }
    | CreateEventAction
    | EditEventAction { eventId :: !(Id Event) }
    | UpdateEventAction { eventId :: !(Id Event) }
    | DeleteEventAction { eventId :: !(Id Event) }
    deriving (Eq, Show, Data)

data ReservationsController
    = ReservationsAction  {eventId :: !(Id Event)}
    | NewReservationAction  {eventId :: !(Id Event)}
    | ShowReservationAction { reservationId :: !(Id Reservation) }
    | CreateReservationAction
    | DeleteReservationAction { reservationId :: !(Id Reservation) }
    deriving (Eq, Show, Data)