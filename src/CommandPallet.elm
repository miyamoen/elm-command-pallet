module CommandPallet exposing
    ( Model(..)
    , Msg
    , element
    , html
    , init
    , showUpMsg
    , subscriptions
    , subscriptionsWithKey
    , update
    )

import Element exposing (Element, inFront, layout, none)
import Html exposing (Html)
import Keyboard.Key exposing (Key(..))
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


element : Model msg -> Element msg
element (CommandPallet model) =
    View.view model


html : Model msg -> Html msg
html model =
    layout [ inFront <| element model ] none


subscriptions : Model msg -> Sub msg
subscriptions (CommandPallet model) =
    Update.subscriptions model


subscriptionsWithKey : Key -> Model msg -> Sub msg
subscriptionsWithKey key (CommandPallet model) =
    Update.subscriptionsWithKey key model


showUpMsg : Msg
showUpMsg =
    Types.ShowUp
