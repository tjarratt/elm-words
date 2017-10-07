module WordGameCss exposing (..)

import Css exposing (..)
import Css.Elements exposing (body, li)
import Css.Namespace exposing (namespace)


type CssClasses
    = CurrentWordLabel
    | CurrentWord
    | CurrentWordSelected
    | CurrentColor
    | CurrentColorText
    | CurrentColorTextSelected
    | GameModeList
    | GameModeButton


type CssIds
    = Page


css =
    (stylesheet << namespace "wordgame")
        [ body
            [ margin (px 20)
            , backgroundColor <| rgb 217 217 217
            ]
        , class GameModeList
            [ position fixed
            , left (pct 50)
            , top (pct 50)
            , transform <| translate2 (pct -50) (pct -50)
            ]
        , class GameModeButton
            [ display block
            , margin (px 40)
            , (fontSize (pct 400))
            , padding2 (px 5) (px 45)
            ]
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
            , property "user-select" "none"
            , cursor default
            ]
        , class CurrentWordSelected
            [ color (hex "f3336c") ]
        , class CurrentColor
            [ width (px 200)
            , height (px 200)
            , border3 (px 3) dashed (rgb 5 5 5)
            ]
        , class CurrentColorText
            [ fontSize (pct 500)
            , position fixed
            , left (pct 50)
            , top (pct 70)
            , transform <| translate2 (pct -50) (pct -70)
            , property "user-select" "none"
            , cursor default
            ]
        , class CurrentColorTextSelected
            [ border3 (px 3) solid (rgb 250 10 0) ]
        ]
