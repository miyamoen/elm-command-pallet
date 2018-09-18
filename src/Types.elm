module Types exposing (Model, Msg(..))

import SelectList exposing (SelectList)


type alias Model msg =
    { filter : String
    , msgs : List ( String, msg )
    , filtered : Maybe (SelectList ( String, msg ))
    , isVisible : Bool
    }


type Msg
    = ShowUp
    | Close
    | Input String
    | UpCursor
    | DownCursor
    | Confirm
