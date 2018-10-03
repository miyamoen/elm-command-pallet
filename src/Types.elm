module Types exposing (Command, Filtered, Fragment, Model, Msg(..), inputId, logMsg)

import SelectList exposing (SelectList)


type alias Model msg =
    { filter : String
    , commands : List (Command msg)
    , filtered : Filtered msg
    , isVisible : Bool
    , toMsg : Msg -> msg
    }


type alias Filtered msg =
    Maybe (SelectList (Command msg))


type alias Command msg =
    { label : String
    , msg : msg
    , fragments : List Fragment
    , index : Int
    }


type alias Fragment =
    { text : String, matched : Bool }


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
