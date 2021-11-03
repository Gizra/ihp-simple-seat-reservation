module Web.View.Venues.Edit where
import Web.View.Prelude

data EditView = EditView { venue :: Venue }

instance View EditView where
    html EditView { .. } = [hsx|
        {breadcrumb}
        <h1>Edit Venue</h1>
        {renderForm venue}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Venues" VenuesAction
                , breadcrumbText "Edit Venue"
                ]

renderForm :: Venue -> Html
renderForm venue = formFor venue [hsx|
    {(textField #title)}
    {(textField #totalNumberOfSeats)}
    {submitButton}

|]