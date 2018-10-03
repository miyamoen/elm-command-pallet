module Update exposing (init, subscriptions, update)

import Browser.Dom as Dom
import Browser.Events
import Command
import Keyboard.Event exposing (considerKeyboardEvent)
import Keyboard.Key exposing (Key(..))
import SelectList exposing (Direction(..))
import Task
import Types exposing (..)


init : (Msg -> msg) -> List ( String, msg ) -> Model msg
init toMsg msgs =
    let
        commands =
            List.map (\( label, msg ) -> Command.init label msg) msgs
    in
    { filter = ""
    , commands = commands
    , filtered = SelectList.fromList commands
    , isVisible = False
    , toMsg = toMsg
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
            Tuple.pair
                { model
                    | isVisible = False
                    , filter = ""
                    , filtered = SelectList.fromList model.commands
                }
                Cmd.none

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
                { model
                    | filtered =
                        Maybe.map
                            (SelectList.attempt (SelectList.changePosition Before 1))
                            model.filtered
                }
                Cmd.none

        DownCursor ->
            Tuple.pair
                { model
                    | filtered =
                        Maybe.map
                            (SelectList.attempt (SelectList.changePosition After 1))
                            model.filtered
                }
                Cmd.none

        Confirm ->
            Tuple.pair
                { model
                    | isVisible = False
                    , filter = ""
                    , filtered = SelectList.fromList model.commands
                }
                Cmd.none


subscriptions : Model msg -> Sub msg
subscriptions { isVisible, toMsg } =
    Sub.batch
        [ Browser.Events.onKeyDown <|
            considerKeyboardEvent
                (\{ ctrlKey, shiftKey, keyCode } ->
                    case ( isVisible, keyCode ) of
                        ( False, P ) ->
                            Just ShowUp

                        ( True, Escape ) ->
                            Just Close

                        _ ->
                            Nothing
                )
        ]
        |> Sub.map toMsg
