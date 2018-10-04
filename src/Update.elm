module Update exposing (init, subscriptions, subscriptionsWithKey, update)

import Browser.Dom as Dom
import Browser.Events
import Command
import Json.Decode exposing (Decoder)
import Keyboard.Event exposing (considerKeyboardEvent)
import Keyboard.Key exposing (Key(..))
import SelectList exposing (Direction(..))
import Task
import Types exposing (..)


init : (Msg -> msg) -> List ( String, msg ) -> Model msg
init toMsg msgs =
    let
        commands =
            List.indexedMap
                (\index ( label, msg ) -> Command.init index label msg)
                msgs
    in
    { filter = ""
    , commands = commands
    , filtered = SelectList.fromList commands
    , isVisible = False
    , toMsg = toMsg
    }


reset : Model msg -> Model msg
reset model =
    { model
        | isVisible = False
        , filter = ""
        , filtered = SelectList.fromList model.commands
    }


update : Msg -> Model msg -> ( Model msg, Cmd msg )
update msg model =
    case msg of
        NoOp ->
            Tuple.pair model Cmd.none

        ShowUp ->
            Tuple.pair { model | isVisible = True } <|
                Task.attempt (\_ -> model.toMsg NoOp) (Dom.focus inputId)

        Close ->
            Tuple.pair (reset model) Cmd.none

        Input input ->
            Tuple.pair
                { model
                    | filter = input
                    , filtered =
                        if String.isEmpty input then
                            SelectList.fromList model.commands

                        else
                            Command.filter input model.commands
                }
                Cmd.none

        UpCursor ->
            Tuple.pair
                { model | filtered = Maybe.map Command.upCursor model.filtered }
                Cmd.none

        DownCursor ->
            Tuple.pair
                { model | filtered = Maybe.map Command.downCursor model.filtered }
                Cmd.none

        Confirm ->
            case model.filtered of
                Just command ->
                    Tuple.pair (reset model) <|
                        Task.perform identity
                            (Task.succeed <| .msg <| SelectList.selected command)

                Nothing ->
                    Tuple.pair model Cmd.none


subscriptionsWithKey : Key -> Model msg -> Sub msg
subscriptionsWithKey key { isVisible, toMsg } =
    Browser.Events.onKeyDown (showUpDecoder key isVisible)
        |> Sub.map toMsg


subscriptions : Model msg -> Sub msg
subscriptions model =
    subscriptionsWithKey P model


showUpDecoder : Key -> Bool -> Decoder Msg
showUpDecoder key isVisible =
    considerKeyboardEvent
        (\{ ctrlKey, shiftKey, keyCode } ->
            case ( isVisible, keyCode == key ) of
                ( False, True ) ->
                    Just ShowUp

                _ ->
                    Nothing
        )
