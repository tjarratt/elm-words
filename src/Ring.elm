module Ring
    exposing
        ( Ring
        , initialize
        , fromList
        , value
        , advance
        , push
        , toArray
        )

import Array
import Array.NonEmpty as NEA
import Debug


type alias Ring a =
    { members : NEA.NonEmptyArray a
    , currentIndex : Int
    }


initialize : a -> Ring a
initialize head =
    { members = NEA.fromElement head
    , currentIndex = 0
    }


fromList : List a -> Ring a
fromList list =
    let
        nonemptyMembers =
            case NEA.fromList list of
                Just a ->
                    a

                Nothing ->
                    Debug.crash "Don't initialize a ring with an empty list"
    in
        { members = nonemptyMembers
        , currentIndex = 0
        }


value : Ring a -> a
value ring =
    NEA.getSelected ring.members


advance : Ring a -> Ring a
advance ring =
    { ring
        | currentIndex = nextIndex ring
        , members = NEA.setSelectedIndex (nextIndex ring) ring.members
    }


nextIndex : Ring a -> Int
nextIndex ring =
    if ring.currentIndex == (NEA.length ring.members - 1) then
        0
    else
        ring.currentIndex + 1


push : a -> Ring a -> Ring a
push newMember ring =
    { ring | members = NEA.push newMember ring.members }


toArray : Ring a -> Array.Array a
toArray ring =
    Array.fromList <| NEA.toList ring.members
