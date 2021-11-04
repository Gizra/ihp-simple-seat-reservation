module Web.View.Reservations.New where
import Web.View.Prelude

data NewView = NewView
    { reservation :: Reservation
    , event :: Event
    , venue :: Venue
    }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}

        <h1 class="text-3xl">New Reservation</h1>
        {renderForm reservation}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink ("Venue opening for " ++ cs (get #title venue)) $ ShowEventAction (get #id event)
                , breadcrumbText "New Reservation"
                ]

renderForm :: Reservation -> Html
renderForm reservation = formFor reservation [hsx|
    {(hiddenField #eventId)}
    {(textField #personIdentifier) { required = True, helpText = "Enter a dummy Person ID. If it starts with 0000 or not only alpha numeric, it will be rejected.", fieldLabel ="Person ID" }}
    {submitButton}
|]
