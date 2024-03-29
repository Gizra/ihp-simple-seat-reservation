module Web.Controller.Events where

import Web.Controller.Prelude
import Web.View.Events.New
import Web.View.Events.Edit
import Web.View.Events.Show

instance Controller EventsController where
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
        venue <- fetch event.venueId
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
                    venue <- fetch event.venueId
                    render NewView { .. }
                Right event -> do
                    event <- event |> createRecord
                    setSuccessMessage "Event created"
                    redirectTo $ ShowEventAction event.id

    action DeleteEventAction { eventId } = do
        event <- fetch eventId
        deleteRecord event
        setSuccessMessage "Event deleted"
        redirectTo VenuesAction

buildEvent event = event
    |> fill @'["venueId", "title", "startTime", "endTime"]
    |> validateField #title nonEmpty
