module Web.Controller.Events where

import Web.Controller.Prelude
import Web.View.Events.Index
import Web.View.Events.New
import Web.View.Events.Edit
import Web.View.Events.Show

instance Controller EventsController where
    action EventsAction { venueId } = do
        (eventsQ, pagination) <- query @Event |> filterWhere (#venueId, venueId) |> paginate
        events <- eventsQ |> fetch
        render IndexView { .. }

    action NewEventAction { venueId } = do
        current <- getCurrentTime
        let event = newRecord
                |> set #venueId venueId
                |> set #startTime current
                -- Add one hour.
                |> set #endTime (addUTCTime (secondsToNominalDiffTime $ 60 * 60) current)

        venue <- fetch venueId
        render NewView { .. }

    action ShowEventAction { eventId } = autoRefresh do
        event <- fetch eventId
        venue <- fetch (get #venueId event)
        reservations <- query @Reservation
                |> filterWhere (#eventId, eventId)
                |> orderByDesc #createdAt
                |> fetch

        trackTableRead "reservations"

        render ShowView { .. }

    action EditEventAction { eventId } = do
        event <- fetch eventId
        render EditView { .. }

    action UpdateEventAction { eventId } = do
        event <- fetch eventId
        event
            |> buildEvent
            |> ifValid \case
                Left event -> render EditView { .. }
                Right event -> do
                    event <- event |> updateRecord
                    setSuccessMessage "Event updated"
                    redirectTo EditEventAction { .. }

    action CreateEventAction = do
        let event = newRecord @Event
        event
            |> buildEvent
            |> ifValid \case
                Left event -> do
                    venue <- fetch (get #venueId event)
                    render NewView { .. }
                Right event -> do
                    event <- event |> createRecord
                    setSuccessMessage "Event created"
                    redirectTo $ EventsAction (get #venueId event)

    action DeleteEventAction { eventId } = do
        event <- fetch eventId
        deleteRecord event
        setSuccessMessage "Event deleted"
        redirectTo VenuesAction

buildEvent event = event
    |> fill @'["venueId", "title", "startTime", "endTime"]
