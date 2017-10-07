module App
    exposing
        ( Model
        , model
        , view
        , update
        )

import Array exposing (..)
import Css
import Html exposing (Html)
import Html.Attributes
import Html.CssHelpers
import Html.Events exposing (on, keyCode)
import Json.Decode as Json
import Keyboard
import List
import Mouse
import Random
import Ring
import Task
import Time
import Tuple
import WordGameCss


{ id, class, classList } =
    Html.CssHelpers.withNamespace "wordgame"


type Msg
    = KeyUpMsg Keyboard.KeyCode
    | ClickMsg Mouse.Position
    | SpacebarPressed
    | AdvanceIfNecessary
    | SelectedColorsMode
    | SelectedWordsMode


type GameMode
    = PracticeColors
    | PracticeWords


type SelectionIndex
    = NoSelection
    | Everything
    | Indexed Int
    | EverythingAgain
    | AdvanceToNextWord


advanceSelectionIndex : String -> SelectionIndex -> SelectionIndex
advanceSelectionIndex word selection =
    case selection of
        NoSelection ->
            Everything

        Everything ->
            Indexed 0

        Indexed i ->
            if i == ((String.length word) - 1) then
                EverythingAgain
            else
                Indexed (i + 1)

        EverythingAgain ->
            AdvanceToNextWord

        AdvanceToNextWord ->
            AdvanceToNextWord


type alias Model =
    { gameMode : Maybe GameMode
    , words : Ring.Ring String
    , selectedIndex : SelectionIndex
    , colors : Ring.Ring ( String, String )
    , colorsVisible : ColorsVisible
    }


type ColorsVisible
    = JustTheColor
    | ColorAndEnglish
    | ColorAndEnglishAndFrench


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )


model : Model
model =
    { gameMode = Nothing
    , words = Ring.fromList englishWordsToPractice
    , selectedIndex = NoSelection
    , colors = Ring.fromList colors
    , colorsVisible = JustTheColor
    }


gameModeButton : String -> Msg -> Html Msg
gameModeButton title msg =
    Html.button
        [ class [ WordGameCss.GameModeButton ]
        , Html.Events.onClick msg
        ]
        [ Html.text title ]


view : Model -> Html Msg
view model =
    case model.gameMode of
        Nothing ->
            Html.div [ class [ WordGameCss.GameModeList ] ]
                [ gameModeButton "Colors" SelectedColorsMode
                , gameModeButton "Words" SelectedWordsMode
                ]

        Just PracticeWords ->
            Html.div []
                [ Html.span
                    [ class
                        (List.append
                            [ WordGameCss.CurrentWord ]
                            (cssClassesForSelectionIndex model.selectedIndex)
                        )
                    ]
                    ((String.toList <| Ring.value model.words)
                        |> List.map String.fromChar
                        |> (List.indexedMap (\index c -> Html.span [ class <| cssForLetterAtIndex index model ] [ Html.text c ]))
                    )
                ]

        Just PracticeColors ->
            case model.colorsVisible of
                JustTheColor ->
                    let
                        theColor =
                            Tuple.first <| Ring.value model.colors

                        colorCode =
                            (hexCodeForColor theColor)
                    in
                        Html.div [] [ colorBlock colorCode ]

                ColorAndEnglish ->
                    let
                        theColor =
                            Tuple.first <| Ring.value model.colors

                        colorCode =
                            (hexCodeForColor theColor)
                    in
                        Html.div []
                            [ colorBlock colorCode
                            , Html.span
                                [ class <|
                                    List.append
                                        [ WordGameCss.CurrentColorText ]
                                        (cssClassesForSelectionIndex model.selectedIndex)
                                ]
                                ((String.toList <| theColor)
                                    |> List.map String.fromChar
                                    |> (List.indexedMap (\index c -> Html.span [ class <| cssForLetterAtIndex index model ] [ Html.text c ]))
                                )
                            ]

                ColorAndEnglishAndFrench ->
                    Html.div [] []


colorBlock : String -> Html Msg
colorBlock colorCode =
    Html.span
        [ class [ WordGameCss.CurrentWord, WordGameCss.CurrentColor ]
        , Html.Attributes.style [ ( "backgroundColor", colorCode ) ]
        ]
        [ Html.text " " ]


cssForLetterAtIndex : Int -> Model -> List WordGameCss.CssClasses
cssForLetterAtIndex index model =
    case model.selectedIndex of
        Indexed i ->
            if index == i then
                [ WordGameCss.CurrentWordSelected ]
            else
                []

        _ ->
            []


cssClassesForSelectionIndex : SelectionIndex -> List WordGameCss.CssClasses
cssClassesForSelectionIndex index =
    case index of
        NoSelection ->
            []

        Everything ->
            [ WordGameCss.CurrentWordSelected ]

        EverythingAgain ->
            [ WordGameCss.CurrentWordSelected ]

        _ ->
            []


hexCodeForColor : String -> String
hexCodeForColor color =
    case color of
        "red" ->
            "#EB0500"

        "blue" ->
            "#0066EB"

        "yellow" ->
            "#EBDF00"

        "green" ->
            "#00EB38"

        "orange" ->
            "#EBA000"

        "purple" ->
            "#B200EB"

        "black" ->
            "#000000"

        "white" ->
            "#FFFFFF"

        "brown" ->
            "#895B1A"

        "pink" ->
            "#E845BE"

        _ ->
            "#WHOOPS"


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( updateModel msg model, Cmd.none )


updateModel : Msg -> Model -> Model
updateModel msg model =
    case msg of
        SelectedColorsMode ->
            { model | gameMode = Just PracticeColors }

        SelectedWordsMode ->
            { model | gameMode = Just PracticeWords }

        KeyUpMsg i ->
            handleKeyUp model i

        SpacebarPressed ->
            handleSpacebar model

        ClickMsg pos ->
            handleMouseClick pos model

        AdvanceIfNecessary ->
            handleAdvance model


handleKeyUp : Model -> Int -> Model
handleKeyUp model i =
    if i == 32 then
        updateModel SpacebarPressed model
    else
        model


handleSpacebar : Model -> Model
handleSpacebar model =
    let
        newModel =
            case model.gameMode of
                Nothing ->
                    model

                Just PracticeWords ->
                    { model | selectedIndex = advanceSelectionIndex (Ring.value model.words) model.selectedIndex }

                Just PracticeColors ->
                    case model.colorsVisible of
                        JustTheColor ->
                            { model | colorsVisible = ColorAndEnglish }

                        ColorAndEnglish ->
                            { model | selectedIndex = advanceSelectionIndex (Tuple.first <| Ring.value model.colors) model.selectedIndex }

                        ColorAndEnglishAndFrench ->
                            model
    in
        updateModel AdvanceIfNecessary newModel


handleMouseClick : Mouse.Position -> Model -> Model
handleMouseClick position model =
    handleSpacebar model


handleAdvance : Model -> Model
handleAdvance model =
    case model.selectedIndex of
        AdvanceToNextWord ->
            case model.gameMode of
                Just PracticeWords ->
                    { model
                        | words = Ring.advance model.words
                        , selectedIndex = NoSelection
                    }

                Just PracticeColors ->
                    { model
                        | colors = Ring.advance model.colors
                        , selectedIndex = NoSelection
                    }

                Nothing ->
                    model

        _ ->
            model


main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.gameMode of
        Nothing ->
            Sub.none

        Just _ ->
            Sub.batch [ Keyboard.ups KeyUpMsg, Mouse.clicks ClickMsg ]


colors : List ( String, String )
colors =
    [ ( "red", "rouge" )
    , ( "blue", "bleu" )
    , ( "yellow", "jaune" )
    , ( "green", "vert" )
    , ( "orange", "orange" )
    , ( "purple", "violet" )
    , ( "black", "noir" )
    , ( "white", "blanc" )
    , ( "brown", "brun" )
    , ( "pink", "rose" )
    ]


englishWordsToPractice : List String
englishWordsToPractice =
    [ "cat"
    , "fox"
    , "bear"
    , "turtle"
    , "dog"
    , "mommy"
    , "daddy"
    , "baby"
    , "apple"
    , "sandwich"
    , "breakfast"
    , "lunch"
    , "dinner"
    ]


frenchWordsToPractice : List String
frenchWordsToPractice =
    [ "chat"
    , "renard"
    , "ors"
    , "tortue"
    , "chien"
    , "maman"
    , "papa"
    , "bébé"
    , "pomme"
    , "sandwich"
    , "petit déjeuner"
    , "déjeuner"
    , "dîner"
    ]
