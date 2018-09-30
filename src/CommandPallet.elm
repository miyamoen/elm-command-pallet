module CommandPallet exposing (Model(..), Msg, init, subscriptions, update, view)

import Element exposing (Element)
import Types
import Update
import View


type Model msg
    = CommandPallet (Types.Model msg)


type alias Msg =
    Types.Msg


update : Msg -> Model msg -> ( Model msg, Cmd msg )
update msg (CommandPallet model) =
    Update.update msg model
        |> Tuple.mapFirst CommandPallet


init : (Msg -> msg) -> List ( String, msg ) -> Model msg
init toMsg msgs =
    Update.init toMsg msgs
        |> CommandPallet


view : Model msg -> Element msg
view (CommandPallet model) =
    View.view model


subscriptions : Model msg -> Sub msg
subscriptions (CommandPallet model) =
    Update.subscriptions model
