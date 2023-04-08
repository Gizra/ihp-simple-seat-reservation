module Web.Element.ElementWrap where

import Web.View.Prelude
import qualified Text.Blaze.Html5 as Html5
import Text.Blaze.Internal

wrapContainerVerticalSpacingTiny :: Html -> Html
wrapContainerVerticalSpacingTiny element =
    case element of
        Empty _ -> [hsx||]
        _ -> [hsx|<div class="flex flex-col gap-y-2">{element}</div>|]
