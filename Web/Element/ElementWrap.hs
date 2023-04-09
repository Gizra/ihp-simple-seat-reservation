module Web.Element.ElementWrap where

import Web.View.Prelude
import qualified Text.Blaze.Html5 as Html5
import Text.Blaze.Internal

wrapContainerVerticalSpacing :: [Html5.Html] -> Html
wrapContainerVerticalSpacing elements =
    let
        filteredElements =
            filterEmptyElements elements
    in
    case filteredElements of
        [] -> mempty
        _ -> [hsx|<div class="flex flex-col gap-y-5 md:gap-y-6">{forEach filteredElements (\element -> element)}</div>|]



wrapContainerVerticalSpacingTiny :: Html -> Html
wrapContainerVerticalSpacingTiny element =
    case element of
        Empty _ -> [hsx||]
        _ -> [hsx|<div class="flex flex-col gap-y-2">{element}</div>|]


filterEmptyElements :: [Html5.Html] -> [Html5.Html]
filterEmptyElements elements =
    filter (\element ->
                case element of
                    Empty _ -> False
                    _ -> True
                )
                elements