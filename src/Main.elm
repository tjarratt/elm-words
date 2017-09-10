module App exposing
  ( Model
  , model
  , view
  , update
  )

import Html exposing (Html)
import Html.Attributes as Attr

import List
import Random
import Task
import Time
import Tuple

type Msg
  = Msg

type alias Model =
  { words : List String
  , currentWord : Maybe String
  }

model : Model
model =
  let
    words = englishWordsToPractice
  in
    { words = words
    , currentWord = List.head words
    }

view : Model -> Html Msg
view model =
  Html.div []
    [ Html.h1 [ ] [ Html.text "Let's practice words!" ]
    , markupForCurrentWord model.currentWord
    , Html.h2 [ ] [ Html.text "Words we practice:" ]
    , Html.ul
        [ Attr.id "items" ]
        ( List.map (\word -> Html.li [ ] [ Html.text word ]) model.words )
    ]

markupForCurrentWord : Maybe String -> Html Msg
markupForCurrentWord maybeWord =
  case maybeWord of
    Just word -> Html.h2 [ ] [ Html.span [ ] [ Html.text "Current Word:" ]
                             , Html.span [ ] [ Html.text word ]
                             ]
    Nothing   -> Html.div [ ] [ ]

update : Msg -> Model -> Model
update msg model = model

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
