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
    { condition : String
    , msgs : List ( String, msg )
    , selected : Int
    }


init : List ( String, msg ) -> CommandPallet msg
init msgs =
    CommandPallet
        { condition = ""
        , msgs = msgs
        , selected = 0
        }



-- UPDATE


type Msg msg
    = Input String
    | Send


update : Msg msg -> CommandPallet msg -> ( CommandPallet msg, Cmd msg )
update msg (CommandPallet model) =
    case msg of
        Input input ->
            Tuple.pair
                (CommandPallet
                    { model | condition = input }
                )
                Cmd.none

        Send  ->
            Tuple.pair
                (CommandPallet { model | condition = "" })
                ( model.msgs
                |> List.indexedMap Tuple.pair
                |> List.filter (\(i,msg ) -> i == model.selected)
                |> List.head
                |> Maybe.map (Tuple.second>>Tuple.second >> Task.succeed )

                    |> Task.perform identity
                )


showMsgs : String -> List ( String, msg ) -> List ( String, msg )
showMsgs condition msgs =
    msgs
        |> List.filter
            (\( label, _ ) ->
                String.contains
                    (String.toLower condition)
                    (String.toLower label)
            )
        |> List.take 5



-- VIEW


view : CommandPallet msg -> Html (Msg msg)
view (CommandPallet model) =
    div []
        [ input
            [ value model.condition
            , onInput Input
            ]
            []
        , showMsgs model.condition model.msgs
            |> List.indexedMap (\index msg -> viewMsg (index == model.selected) msg)
            |> div []
        ]


viewMsg : Bool -> ( String, msg ) -> Html (Msg msg)
viewMsg selected ( label, msg ) =
    div
        [ style "color" <|
            if selected then
                "blue"

            else
                "black"
        ]
        [ p [] [ text label ] ]
