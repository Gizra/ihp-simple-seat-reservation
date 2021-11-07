module Web.View.Events.New where
import Web.View.Prelude

data NewView = NewView
    { event :: Event
    , venue :: Venue
    }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>New Event</h1>
        {renderForm event}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Events" $ ShowVenueAction (get #venueId event)
                , breadcrumbText "New Event"
                ]

renderForm :: Event -> Html
renderForm event = formFor event [hsx|
    {(textField #title)}
    {(dateTimeField #startTime)}
    {(dateTimeField #endTime)}

    {(hiddenField #venueId)}

    {submitButton}
|]