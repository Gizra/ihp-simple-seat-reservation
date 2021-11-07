module Web.View.Prelude
( module IHP.ViewPrelude
, module Web.View.Layout
, module Generated.Types
, module Web.Types
, module Application.Helper.View
, homeIcon
, linkClass
, tableTdClasses
, tableThClasses
) where

import IHP.ViewPrelude
import Web.View.Layout
import Generated.Types
import Web.Types
import Web.Routes ()
import Application.Helper.View

homeIcon = [hsx|
    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <title>Back to Homepage</title>
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
    </svg>
|]

{-| Classes of a simple link.
-}
linkClass = "text-blue-500 hover:text-blue-600 hover:underline"

{-| Classes of a table data.
-}
tableTdClasses = "px-6 py-4 whitespace-nowrap text-sm font-medium"

{-| Classes of a table header row.
-}
tableThClasses = "px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider" :: Text
