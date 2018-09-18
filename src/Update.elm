module Update exposing (update)

import SelectList
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

        Confirm ->
            { model
                | isVisible = False
                , filter = ""
                , filtered = SelectList.fromList model.msgs
            }


init : List ( String, msg ) -> Model msg
init msgs =
    { filter = ""
    , msgs = msgs
    , filtered = SelectList.fromList msgs
    , isVisible = False
    }
