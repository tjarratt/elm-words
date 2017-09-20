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
    { words : Ring.Ring String
    , selectedIndex : SelectionIndex
    }


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ Keyboard.ups KeyUpMsg, Mouse.clicks ClickMsg ]


model : Model
model =
    { words = Ring.fromList englishWordsToPractice
    , selectedIndex = NoSelection
    }


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.span
            [ class
                (List.append
                    [ WordGameCss.CurrentWord ]
                    (cssClassesForCurrentWord model.selectedIndex)
                )
            ]
            ((String.toList <| Ring.value model.words)
                |> List.map String.fromChar
                |> (List.indexedMap (\index c -> Html.span [ class <| cssForLetterAtIndex index model ] [ Html.text c ]))
            )
        ]


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


cssClassesForCurrentWord : SelectionIndex -> List WordGameCss.CssClasses
cssClassesForCurrentWord index =
    case index of
        NoSelection ->
            []

        Everything ->
            [ WordGameCss.CurrentWordSelected ]

        EverythingAgain ->
            [ WordGameCss.CurrentWordSelected ]

        _ ->
            []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( updateModel msg model, Cmd.none )


updateModel : Msg -> Model -> Model
updateModel msg model =
    case msg of
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
            { model | selectedIndex = advanceSelectionIndex (Ring.value model.words) model.selectedIndex }
    in
        updateModel AdvanceIfNecessary newModel


handleMouseClick : Mouse.Position -> Model -> Model
handleMouseClick position model =
    handleSpacebar model


handleAdvance : Model -> Model
handleAdvance model =
    case model.selectedIndex of
        AdvanceToNextWord ->
            { model
                | words = Ring.advance model.words
                , selectedIndex = NoSelection
            }

        _ ->
            model


main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


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
