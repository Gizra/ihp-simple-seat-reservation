module Web.View.Reservations.New where
import Web.View.Prelude

data NewView = NewView
    { reservation :: Reservation
    , event :: Event
    , venue :: Venue
    }

instance View NewView where
    html NewView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={ShowEventAction (get #id event)}>Venue opening for {get #title venue}</a></li>
                <li class="breadcrumb-item active">New Reservation</li>
            </ol>
        </nav>
        <h1>New Reservation</h1>
        {renderForm reservation}
    |]

renderForm :: Reservation -> Html
renderForm reservation = formFor reservation [hsx|
    {(hiddenField #eventId)}
    {(textField #personIdentifier) { required = True, helpText = "Enter a dummy Person ID. If it starts with 0000 or not only alpha numeric, it will be rejected.", fieldLabel ="Person ID" }}
    {submitButton}
|]
