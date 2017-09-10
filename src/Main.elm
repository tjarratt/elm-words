module App exposing
  ( Model
  , model
  , view
  , update
  )

import WordGameCss

import Css
import Html exposing (Html)
import Html.Attributes
import Html.Events exposing (on, keyCode)
import Json.Decode as Json
import List
import Random
import Task
import Time
import Tuple

import Html.CssHelpers

{ id, class, classList } =
    Html.CssHelpers.withNamespace "wordgame"

type Msg
  = KeyUp Int

type alias Model =
  { words : List String
  , currentWord : Maybe String
  , selectedWordIndex : Maybe Int
  }

model : Model
model =
  let
    words = englishWordsToPractice
  in
    { words = words
    , currentWord = List.head words
    , selectedWordIndex = Nothing
    }


view : Model -> Html Msg
view model =
  Html.div [ ]
    [ Html.h1 [ ] [ Html.text "Let's practice words with Woden!" ]
    , markupForCurrentWord model.currentWord
    , Html.h3 [ ] [ Html.text "Words we practice:" ]
    , Html.ul
        [ Html.Attributes.id "items" ]
        ( List.map (\word -> Html.li [ ] [ Html.text word ]) model.words )
    ]

markupForCurrentWord : Maybe String -> Html Msg
markupForCurrentWord maybeWord =
  case maybeWord of
    Just word -> Html.div [ class [ WordGameCss.CurrentWordContainer ] ]
                          [ Html.h2
                             [ class [ WordGameCss.CurrentWordLabel ] ]
                             [ Html.text "Current word:" ]
                          , Html.span
                             [ class [ WordGameCss.CurrentWord ] ]
                             [ Html.text word ]
                          ]
    Nothing   -> Html.div [ ] [ ]

update : Msg -> Model -> Model
update msg model = model

onKeyUp : (Int -> Msg) -> Html.Attribute Msg
onKeyUp tagger =
  on "keyup" (Json.map tagger keyCode)

main =
  Html.beginnerProgram
    { model = model
    , update = update
    , view = view
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
