module Web.View.Venues.Index where
import Web.View.Prelude

data IndexView = IndexView { venues :: [ Venue ] , pagination :: Pagination }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <div class="flex flex-col space-y-6 mb-12">
            <h1 class="text-3xl">Venues</h1>
            <div>
                <a href={pathTo NewVenueAction} class="btn btn-primary inline-block">+ Add Venue</a>
            </div>
        </div>
        <div>
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-100">
                    <tr>
                        <th class={tableThClasses}>Venue</th>
                        <th class={tableThClasses}>Ops</th>
                    </tr>
                </thead>
                <tbody>{forEach venues renderVenue}</tbody>
            </table>
            {renderPagination pagination}
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink homeIcon VenuesAction
                ]


renderVenue :: Venue -> Html
renderVenue venue = [hsx|
    <tr>
        <td><a class={linkClass} href={ShowVenueAction (get #id venue)}>{get #title venue}</a></td>
        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
            <a href={EditVenueAction (get #id venue)} class={linkClass}>Edit</a>
        </td>
    </tr>
|]