module Web.Controller.Venues where

import Web.Controller.Prelude
import Web.View.Venues.Index
import Web.View.Venues.New
import Web.View.Venues.Edit
import Web.View.Venues.Show
import Web.Controller.Prelude (Venue'(totalNumberOfSeats))

instance Controller VenuesController where
    action VenuesAction = do
        (venuesQ, pagination) <- query @Venue |> paginate
        venues <- venuesQ |> fetch
        render IndexView { .. }

    action NewVenueAction = do
        let venue = newRecord |> set #totalNumberOfSeats 50
        render NewView { .. }

    action ShowVenueAction { venueId } = do
        venue <- fetch venueId

        events <- query @Event
            |> filterWhere (#venueId, venueId)
            |> orderByDesc #startTime
            |>fetch

        render ShowView { .. }

    action EditVenueAction { venueId } = do
        venue <- fetch venueId
        render EditView { .. }

    action UpdateVenueAction { venueId } = do
        venue <- fetch venueId
        venue
            |> buildVenue
            |> ifValid \case
                Left venue -> render EditView { .. }
                Right venue -> do
                    venue <- venue |> updateRecord
                    setSuccessMessage "Venue updated"
                    redirectTo ShowVenueAction { .. }

    action CreateVenueAction = do
        let venue = newRecord @Venue
        venue
            |> buildVenue
            |> ifValid \case
                Left venue -> render NewView { .. }
                Right venue -> do
                    venue <- venue |> createRecord
                    setSuccessMessage "Venue created"
                    redirectTo $ ShowVenueAction (get #id venue)

    action DeleteVenueAction { venueId } = do
        venue <- fetch venueId
        deleteRecord venue
        setSuccessMessage "Venue deleted"
        redirectTo VenuesAction

buildVenue venue = venue
    |> fill @["title","totalNumberOfSeats"]
    |> validateField #totalNumberOfSeats (isGreaterThan 0)
