module Types exposing (Model, Msg(..), inputId)

import SelectList exposing (SelectList)


type alias Model msg =
    { filter : String
    , msgs : List ( String, msg )
    , filtered : Maybe (SelectList ( String, msg ))
    , isVisible : Bool
    , toMsg : Msg -> msg
    }


type Msg
    = NoOp
    | ShowUp
    | Close
    | Input String
    | UpCursor
    | DownCursor
    | Confirm


inputId : String
inputId =
    "miyamoen-elm-command-pallet-input"
