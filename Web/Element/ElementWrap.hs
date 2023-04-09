module Web.Element.ElementWrap where

import Web.View.Prelude
import qualified Text.Blaze.Html5 as Html5
import Text.Blaze.Internal

wrapContainerVerticalSpacing :: [Html5.Html] -> Html5.Html
wrapContainerVerticalSpacing elements =
    let
        filterElements =
            filter (\element ->
                case element of
                    Empty _ -> False
                    _ -> True
                )
                elements
    in
    case filterElements of
        [] -> [hsx||]
        _ -> [hsx|<div class="flex flex-col gap-y-5 md:gap-y-6">{filterElements}</div>|]



wrapContainerVerticalSpacingTiny :: Html -> Html
wrapContainerVerticalSpacingTiny element =
    case element of
        Empty _ -> [hsx||]
        _ -> [hsx|<div class="flex flex-col gap-y-2">{element}</div>|]
