module Web.View.Venues.New where
import Web.View.Prelude

data NewView = NewView { venue :: Venue }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>New Venue</h1>
        {renderForm venue}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink homeIcon VenuesAction
                , breadcrumbText "New Venue"
                ]

renderForm :: Venue -> Html
renderForm venue = formFor venue [hsx|
    {(textField #title)}
    {(textField #totalNumberOfSeats)}
    {submitButton}

|]