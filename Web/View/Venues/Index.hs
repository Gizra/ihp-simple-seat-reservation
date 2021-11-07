module Web.View.Venues.Index where
import Web.View.Prelude

data IndexView = IndexView { venues :: [ Venue ] , pagination :: Pagination }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Index<a href={pathTo NewVenueAction} class="btn btn-primary">+ New</a></h1>
        <div class="table-responsive">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-100">
                    <tr>
                        <th class={thClasses}>Venue</th>
                        <th class={thClasses}>Ops</th>
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

            thClasses = "px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider" :: Text

renderVenue :: Venue -> Html
renderVenue venue = [hsx|
    <tr>
        <td class={tdClasses}><a class="text-blue-500 hover:text-blue-600 hover:underline" href={ShowVenueAction (get #id venue)}>{get #title venue}</a></td>
        <td class={tdClassesWithSeparator}>
            <a href={EditVenueAction (get #id venue)} class="text-muted">Edit</a>
            <a href={DeleteVenueAction (get #id venue)} class="js-delete text-muted">Delete</a>
        </td>
    </tr>
|]
    where
        tdClasses = "px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900" :: Text
        tdClassesWithSeparator = classes ["flex flex-row space-x-2", (tdClasses, True)]