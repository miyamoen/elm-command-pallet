module Types exposing (Model, Msg(..), inputId, logMsg)

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


logMsg : Msg -> String
logMsg msg =
    case msg of
        NoOp ->
            "NoOp"

        ShowUp ->
            "ShowUp"

        Close ->
            "Close"

        Input input ->
            "Input: " ++ input

        UpCursor ->
            "UpCursor"

        DownCursor ->
            "DownCursor"

        Confirm ->
            "Confirm"


inputId : String
inputId =
    "miyamoen-elm-command-pallet-input"
