module WordGameCss exposing (..)

import Css exposing (..)
import Css.Elements exposing (body, li)
import Css.Namespace exposing (namespace)


type CssClasses
    = CurrentWordLabel
    | CurrentWord
    | CurrentWordSelected


type CssIds
    = Page


css =
    (stylesheet << namespace "wordgame")
    [ body
        [ margin (px 20) ]
   , class CurrentWordLabel
        [ display inlineBlock
        , margin4 (px 0) (px 15) (px 0) (px 0)
        ]
   , class CurrentWord
        [ fontSize (pct 500)
        , position fixed
        , left (pct 50)
        , top (pct 50)
        , transform <| translate2 (pct -50) (pct -50)
        ]
   , class CurrentWordSelected
        [ color (hex "f3336c") ]
   ]
