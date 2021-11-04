module Web.View.CustomCSSFramework (customTailwind) where

import IHP.View.CSSFramework -- This is the only import not copied from IHP/View/CSSFramework.hs
import IHP.Prelude
import IHP.FlashMessages.Types
import qualified Text.Blaze.Html5 as Blaze
import Text.Blaze.Html.Renderer.Text (renderHtml)
import IHP.HSX.QQ (hsx)
import IHP.HSX.ToHtml ()
import IHP.View.Types
import IHP.View.Classes

import qualified Text.Blaze.Html5 as H
import Text.Blaze.Html5 ((!), (!?))
import qualified Text.Blaze.Html5.Attributes as A
import IHP.ModelSupport
import IHP.Breadcrumb.Types
import IHP.Pagination.Helpers
import IHP.Pagination.Types
import IHP.View.Types (PaginationView(linkPrevious, pagination))


customTailwind :: CSSFramework
customTailwind = def
    { styledFlashMessage
    , styledSubmitButtonClass
    , styledFormGroupClass
    , styledFormFieldHelp
    , styledInputClass
    , styledInputInvalidClass
    , styledValidationResultClass
    , styledPagination
    , styledPaginationLinkPrevious
    , styledPaginationLinkNext
    , styledPaginationPageLink
    , styledPaginationDotDot
    , styledPaginationItemsPerPageSelector
    , styledBreadcrumb
    , styledBreadcrumbItem
    }
    where
        styledFlashMessage _ (SuccessFlashMessage message) = [hsx|<div class="bg-green-100 border border-green-500 text-green-900 px-4 py-3 rounded relative">{message}</div>|]
        styledFlashMessage _ (ErrorFlashMessage message) = [hsx|<div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative">{message}</div>|]

        styledInputClass FormField {} = "form-control"
        styledInputInvalidClass _ = "is-invalid"

        styledSubmitButtonClass = "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"

        styledFormFieldHelp _ FormField { helpText = "" } = mempty
        styledFormFieldHelp _ FormField { helpText } = [hsx|<p class="text-gray-600 text-xs italic">{helpText}</p>|]

        styledFormGroupClass = "flex flex-wrap -mx-3 mb-6"

        styledValidationResultClass = "text-red-500 text-xs italic"

        styledPagination :: CSSFramework -> PaginationView -> Blaze.Html
        styledPagination _ paginationView@PaginationView {pageUrl, pagination} =
            let
                currentPage = get #currentPage pagination

                previousPageUrl = if hasPreviousPage pagination then pageUrl $ currentPage - 1 else "#"
                nextPageUrl = if hasNextPage pagination then pageUrl $ currentPage + 1 else "#"

                defaultClass = "relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"
                previousClass = classes
                    [ defaultClass
                    , ("disabled", not $ hasPreviousPage pagination)
                    ]
                nextClass = classes
                    [ defaultClass
                    , ("disabled", not $ hasNextPage pagination)
                    ]

                previousMobileOnly =
                    [hsx|
                        <a href={previousPageUrl} class={previousClass}>
                            Previous
                        </a>
                    |]

                nextMobileOnly =
                    [hsx|
                        <a href={nextPageUrl} class={nextClass}>
                            Next
                        </a>
                    |]

            in
            [hsx|
                <div class="bg-white px-4 py-3 flex items-center justify-between border-t border-gray-200 sm:px-6">
                    <div class="flex-1 flex justify-between sm:hidden">
                        {previousMobileOnly}
                        {nextMobileOnly}
                    </div>
                    <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
                        <div class="text-sm text-gray-700">
                            <select class="px-4 py-3" id="maxItemsSelect" onchange="window.location.href = this.options[this.selectedIndex].dataset.url">
                                {get #itemsPerPageSelector paginationView}
                            </select>
                        </div>
                        <div>
                        <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
                            {get #linkPrevious paginationView}

                            {get #pageDotDotItems paginationView}

                            {get #linkNext paginationView}
                        </nav>
                        </div>
                    </div>
                </div>
            |]

        styledPaginationLinkPrevious :: CSSFramework -> Pagination -> ByteString -> Blaze.Html
        styledPaginationLinkPrevious _ pagination@Pagination {currentPage} pageUrl =
            let
                prevClass = classes
                    [ "relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50"
                    , ("disabled", not $ hasPreviousPage pagination)
                    ]

                url = if hasPreviousPage pagination then pageUrl else "#"

            in
                [hsx|
                    <a href={url} class={prevClass}>
                        <span class="sr-only">Previous</span>
                        <!-- Heroicon name: solid/chevron-left -->
                        <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                            <path fill-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" />
                        </svg>
                    </a>
                |]

        styledPaginationLinkNext :: CSSFramework -> Pagination -> ByteString -> Blaze.Html
        styledPaginationLinkNext _ pagination@Pagination {currentPage} pageUrl =
            let
                nextClass = classes
                    [ "relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50"
                    , ("disabled", not $ hasNextPage pagination)
                    ]

                url = if hasNextPage pagination then pageUrl else "#"
            in
                [hsx|
                    <a href={url} class={nextClass}>
                        <span class="sr-only">Next</span>
                        <!-- Heroicon name: solid/chevron-right -->
                        <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                            <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />
                        </svg>
                    </a>

                |]

        styledPaginationPageLink :: CSSFramework -> Pagination -> ByteString -> Int -> Blaze.Html
        styledPaginationPageLink _ pagination@Pagination {currentPage} pageUrl pageNumber =
            let
                linkClass = classes
                    [ "relative inline-flex items-center px-4 py-2 border text-sm font-medium"
                    -- Current page
                    , ("z-10 bg-indigo-50 border-indigo-500 text-indigo-600", pageNumber == currentPage)
                    -- Not current page
                    , ("bg-white border-gray-300 text-gray-500 hover:bg-gray-50", pageNumber /= currentPage)
                    ]
            in
                [hsx|
                    <a href={pageUrl} aria-current={pageNumber == currentPage} class={linkClass}>
                        {show pageNumber}
                    </a>
                |]


        styledPaginationDotDot :: CSSFramework -> Pagination -> Blaze.Html
        styledPaginationDotDot _ _ =
            [hsx|
                <span class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700">
                    ...
                </span>
        |]


        styledPaginationItemsPerPageSelector :: CSSFramework -> Pagination -> (Int -> ByteString) -> Blaze.Html
        styledPaginationItemsPerPageSelector _ pagination@Pagination {pageSize} itemsPerPageUrl =
            let
                oneOption :: Int -> Blaze.Html
                oneOption n = [hsx|<option value={show n} selected={n == pageSize} data-url={itemsPerPageUrl n}>{n} items per page</option>|]
            in
                [hsx|{forEach [10,20,50,100,200] oneOption}|]


        styledBreadcrumb :: CSSFramework -> [BreadcrumbItem]-> BreadcrumbsView -> Blaze.Html
        styledBreadcrumb _ _ breadcrumbsView = [hsx|
            <nav class="breadcrumbs bg-gray-100 py-4 px-6 rounded my-4" aria-label="Breadcrumb">
                <ol class="flex items-center space-x-2" role="list">
                    {get #breadcrumbItems breadcrumbsView}
                </ol>
            </nav>
        |]


        styledBreadcrumbItem :: CSSFramework -> [ BreadcrumbItem ]-> BreadcrumbItem -> Bool -> Blaze.Html
        styledBreadcrumbItem _ breadcrumbItems breadcrumbItem@BreadcrumbItem {breadcrumbLabel, url} isLast =
            let
                breadcrumbsClasses = classes ["flex flex-row space-x-2 text-gray-600 items-center", ("active", isLast)]

                -- Show chevron if item isn't the active one (i.e. the last one).
                chevronRight = unless isLast [hsx|
                <!-- heroicons.com chevron-right -->
                <svg xmlns="http://www.w3.org/2000/svg" class="flex-shrink-0 h-4 w-4 text-gray-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                </svg>
                |]
            in
            case url of
                Nothing ->  [hsx|
                    <li class={breadcrumbsClasses}>
                        {breadcrumbLabel}
                        {chevronRight}
                    </li>
                |]
                Just url -> [hsx|
                    <li class={breadcrumbsClasses}>
                        <a class="hover:text-gray-700" href={url}>{breadcrumbLabel}</a>
                        {chevronRight}
                    </li>
                    |]