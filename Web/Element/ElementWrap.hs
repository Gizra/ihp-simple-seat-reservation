module Web.Element.ElementWrap where

import Web.View.Prelude
import qualified Text.Blaze.Html5 as Html5

wrapContainerVerticalSpacingTiny :: Html -> Html
wrapContainerVerticalSpacingTiny element =
    [hsx|<div class="flex flex-col gap-y-2">{element}</div>|]
