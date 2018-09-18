module Update exposing (update)

import Types exposing (..)


update : Msg -> Model msg -> ( Model msg, Cmd msg )
update msg model =
    case msg of
        ShowUp ->
            Tuple.pair { model | isVisible = True } Cmd.none

        Close ->
            Tuple.pair
                { model
                    | isVisible = False
                    , filter = ""
                    , filtered = model.msgs
                }
                Cmd.none

        Input input ->
            Tuple.pair { model | filter = input } Cmd.none

        Confirm ->
            Tuple.pair
                { model
                    | isVisible = False
                    , filter = ""
                    , filtered = model.msgs
                }
                Cmd.none
