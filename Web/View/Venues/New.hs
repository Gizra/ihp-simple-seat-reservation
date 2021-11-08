module Web.View.Venues.New where
import Web.View.Prelude
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

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
    {(numberField #totalNumberOfSeats) { fieldInput = (\fieldInput -> H.input ! A.min "1") } }
    {submitButton}

|]