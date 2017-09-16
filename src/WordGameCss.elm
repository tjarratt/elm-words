module WordGameCss exposing (..)

import Css exposing (..)
import Css.Elements exposing (body, li)
import Css.Namespace exposing (namespace)


type CssClasses
    = CurrentWordLabel
    | CurrentWord
    | CurrentWordSelected
    | CurrentWordContainer


type CssIds
    = Page


css =
    (stylesheet << namespace "wordgame")
    [ body
        [ margin (px 20) ]
   , class CurrentWordContainer
        [ margin4 (px 50) (px 0) (px 100) (px 0) ]
   , class CurrentWordLabel
        [ display inlineBlock
        , margin4 (px 0) (px 15) (px 0) (px 0)
        ]
   , class CurrentWord
        [ fontSize (pct 500) ]
   , class CurrentWordSelected
        [ color (hex "f3336c") ]
   ]
