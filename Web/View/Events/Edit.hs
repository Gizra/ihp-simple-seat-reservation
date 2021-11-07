module Web.View.Events.Edit where
import Web.View.Prelude

data EditView = EditView { event :: Event }

instance View EditView where
    html EditView { .. } = [hsx|
        {breadcrumb}
        <h1>Edit Event</h1>
        {renderForm event}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Events" $ ShowEventAction (get #id event)
                , breadcrumbText "Edit Event"
                ]

renderForm :: Event -> Html
renderForm event = formFor event [hsx|
    {(textField #title)}
    {(dateTimeField #startTime)}
    {(dateTimeField #endTime)}

    {(hiddenField #venueId)}

    {submitButton}
|]
