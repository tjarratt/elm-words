module App exposing
  ( Model
  , model
  , view
  , update
  )

import Html exposing (Html)
import Html.Attributes as Attr

type Msg
  = Msg

type alias Model =
  { items : List String
  }

model : Model
model =
  { items = []
  }

view : Model -> Html Msg
view model =
  Html.div []
    [ Html.h1 [ ] [ Html.text "Let's practice words!" ]
    , Html.ul [ Attr.id "items" ] []
    ]

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
