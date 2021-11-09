module Web.View.Reservations.New where
import Web.View.Prelude
import Web.Types (EventsController(ShowEventAction))

data NewView = NewView
    { reservation :: Reservation
    , event :: Event
    , venue :: Venue
    }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}

        <h1>New Reservation</h1>
        {renderForm reservation}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink homeIcon $ VenuesAction
                , breadcrumbLink (cs (get #title venue)) $ ShowVenueAction (get #venueId event)
                , breadcrumbLink (cs (get #title event)) $ ShowEventAction (get #id event)
                , breadcrumbText "New Reservation"
                ]

renderForm :: Reservation -> Html
renderForm reservation = formFor reservation [hsx|
    {(hiddenField #eventId)}
    {(textField #personIdentifier) { required = True, helpText = "Enter a dummy Person ID. If it starts with 0000 or not only alpha numeric, it will be rejected.", fieldLabel ="Person ID" }}
    {(checkboxField #delay) { helpText = "If checked, the processing of the Reservation will be delayed by 2 seconds." }}
    {submitButton}
|]
