module Update exposing (init, logMsg, subscriptions, update)

import Browser.Events
import Keyboard.Event exposing (considerKeyboardEvent)
import Keyboard.Key exposing (Key(..))
import SelectList exposing (Direction(..))
import Types exposing (..)


update : Msg -> Model msg -> Model msg
update msg model =
    case msg of
        ShowUp ->
            { model | isVisible = True }

        Close ->
            { model
                | isVisible = False
                , filter = ""
                , filtered = SelectList.fromList model.msgs
            }

        Input input ->
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

        UpCursor ->
            { model
                | filtered =
                    Maybe.map
                        (SelectList.attempt (SelectList.changePosition Before 1))
                        model.filtered
            }

        DownCursor ->
            { model
                | filtered =
                    Maybe.map
                        (SelectList.attempt (SelectList.changePosition After 1))
                        model.filtered
            }

        Confirm ->
            { model
                | isVisible = False
                , filter = ""
                , filtered = SelectList.fromList model.msgs
            }


subscriptions : (Msg -> msg) -> Model msg -> Sub msg
subscriptions toMsg { isVisible } =
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


init : List ( String, msg ) -> Model msg
init msgs =
    { filter = ""
    , msgs = msgs
    , filtered = SelectList.fromList msgs
    , isVisible = False
    }


logMsg : Msg -> String
logMsg msg =
    case msg of
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
