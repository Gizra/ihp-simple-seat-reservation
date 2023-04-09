module Web.Element.Button where

import Web.View.Prelude
import qualified Text.Blaze.Html5 as Html5
import IHP.RouterSupport

-- buildButton :: Text -> Html
buildButton :: (IHP.RouterSupport.HasPath path) => Text -> path -> Html
buildButton text action =
        [hsx|
            <a href={pathTo $ action } class="inline-block px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 focus:ring-2 focus:ring-blue-600 focus:ring-offset-2 focus:outline-none">{text}</a>
        |]


