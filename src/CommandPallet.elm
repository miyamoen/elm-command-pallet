module CommandPallet exposing (Model(..), Msg, init, subscriptions, update, view)

import Element exposing (Element)
import Types
import Update
import View


type Model msg
    = CommandPallet (Types.Model msg)


type alias Msg =
    Types.Msg


update : Msg -> Model msg -> Model msg
update msg (CommandPallet model) =
    Update.update msg model
        |> CommandPallet


init : List ( String, msg ) -> Model msg
init msgs =
    Update.init msgs
        |> CommandPallet


view : (Msg -> msg) -> Model msg -> Element msg
view toMsg (CommandPallet model) =
    View.view toMsg model


subscriptions : (Msg -> msg) -> Model msg -> Sub msg
subscriptions toMsg (CommandPallet model) =
    Update.subscriptions toMsg model
