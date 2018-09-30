module Update exposing (init, subscriptions, update)

import Browser.Dom as Dom
import Browser.Events
import Keyboard.Event exposing (considerKeyboardEvent)
import Keyboard.Key exposing (Key(..))
import SelectList exposing (Direction(..))
import Task
import Types exposing (..)


init : (Msg -> msg) -> List ( String, msg ) -> Model msg
init toMsg msgs =
    { filter = ""
    , msgs = msgs
    , filtered = SelectList.fromList msgs
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
                    , filtered = SelectList.fromList model.msgs
                }
                Cmd.none

        Input input ->
            Tuple.pair
                { model
                    | filter = input
                    , filtered =
                        List.filter
                            (\( label, _ ) ->
                                String.contains (String.toLower input) label
                            )
                            model.msgs
                            |> SelectList.fromList
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
                    , filtered = SelectList.fromList model.msgs
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
