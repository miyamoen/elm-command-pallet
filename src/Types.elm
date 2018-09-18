module Types exposing (Model, Msg(..))

import SelectList exposing (SelectList)


type alias Model msg =
    { filter : String
    , msgs : SelectList ( String, msg )
    , filtered : SelectList ( String, msg )
    , isVisible : Bool
    }


type Msg
    = ShowUp
    | Close
    | Input String
    | Confirm
