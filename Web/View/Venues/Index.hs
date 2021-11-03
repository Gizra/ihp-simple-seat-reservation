module Web.View.Venues.Index where
import Web.View.Prelude

data IndexView = IndexView { venues :: [ Venue ] , pagination :: Pagination }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Index<a href={pathTo NewVenueAction} class="btn btn-primary ml-4">+ New</a></h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Venue</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach venues renderVenue}</tbody>
            </table>
            {renderPagination pagination}
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Venues" VenuesAction
                ]

renderVenue :: Venue -> Html
renderVenue venue = [hsx|
    <tr>
        <td>{venue}</td>
        <td><a href={ShowVenueAction (get #id venue)}>Show</a></td>
        <td><a href={EditVenueAction (get #id venue)} class="text-muted">Edit</a></td>
        <td><a href={DeleteVenueAction (get #id venue)} class="js-delete text-muted">Delete</a></td>
    </tr>
|]