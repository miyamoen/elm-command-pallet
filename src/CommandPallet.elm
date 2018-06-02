module CommandPallet exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onBlur, onClick, onFocus, onInput)
import Task


-- MODEL


type CommandPallet msg
    = CommandPallet (Record msg)


type alias Record msg =
    { input : String
    , shows : List ( String, msg )
    , msgs : List ( String, msg )
    }


init : List ( String, msg ) -> CommandPallet msg
init msgs =
    CommandPallet
        { input = ""
        , shows = []
        , msgs = msgs
        }



-- UPDATE


type Msg msg
    = Input String
    | Focus
    | Blur
    | Select ( String, msg )


update : Msg msg -> CommandPallet msg -> ( CommandPallet msg, Cmd msg )
update msg (CommandPallet model) =
    case msg of
        Input input ->
            Tuple.pair
                (CommandPallet
                    { model
                        | input = input
                        , shows = showMsgs input model.msgs
                    }
                )
                Cmd.none

        Focus ->
            Tuple.pair
                (CommandPallet { model | shows = showMsgs model.input model.msgs })
                Cmd.none

        Blur ->
            Tuple.pair
                (CommandPallet { model | shows = [] })
                Cmd.none

        Select ( label, send ) ->
            Tuple.pair
                (CommandPallet { model | shows = [], input = "" })
                (Task.succeed send
                    |> Task.perform identity
                )


showMsgs : String -> List ( String, msg ) -> List ( String, msg )
showMsgs input msgs =
    msgs
        |> List.filter
            (\( label, _ ) ->
                String.contains
                    (String.toLower input)
                    (String.toLower label)
            )
        |> List.take 5



-- VIEW


view : CommandPallet msg -> Html (Msg msg)
view (CommandPallet model) =
    div []
        [ input
            [ value model.input
            , onInput Input
            , onFocus Focus
            , onBlur Blur
            ]
            []
        , div [] <|
            List.map (\( label, msg ) -> p [] [ text label ]) model.shows
        ]
