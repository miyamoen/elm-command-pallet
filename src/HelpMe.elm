module HelpMe exposing (Model)

import Browser
import CommandPallet as CP
import Element exposing (..)
import Element.Input exposing (button)
import Html exposing (Html)


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { num : Int
    , commandPallet : CP.Model Msg
    }


init : ( Model, Cmd Msg )
init =
    ( { num = 0
      , commandPallet =
            CP.init CommandPalletMsg
                [ Tuple.pair "Increment" Increment
                , Tuple.pair "Decrement" Decrement
                , Tuple.pair "1" <| Set 1
                , Tuple.pair "11" <| Set 11
                , Tuple.pair "123" <| Set 123
                , Tuple.pair "151" <| Set 151
                , Tuple.pair "100" <| Set 100
                , Tuple.pair "101" <| Set 101
                , Tuple.pair "900" <| Set 900
                ]
      }
    , Cmd.none
    )


type Msg
    = NoOp
    | Increment
    | Decrement
    | Set Int
    | CommandPalletMsg CP.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            Tuple.pair model Cmd.none

        Increment ->
            Tuple.pair { model | num = model.num + 1 } Cmd.none

        Decrement ->
            Tuple.pair { model | num = model.num - 1 } Cmd.none

        Set num ->
            Tuple.pair { model | num = num } Cmd.none

        CommandPalletMsg subMsg ->
            let
                ( cp, cmd ) =
                    CP.update subMsg model.commandPallet
            in
            Tuple.pair
                { model | commandPallet = cp }
                cmd


subscriptions : Model -> Sub Msg
subscriptions { commandPallet } =
    CP.subscriptions commandPallet


view : Model -> Html Msg
view { num, commandPallet } =
    layout [ inFront <| CP.view commandPallet ] <|
        column [ width fill, height fill, explain Debug.todo ]
            [ row [ width fill, height fill, spacing 5 ]
                [ button [ centerX ]
                    { onPress = Just Decrement, label = el [] <| text "<" }
                , el [ centerX ] <| text <| String.fromInt num
                , button [ centerX ]
                    { onPress = Just Increment, label = el [] <| text ">" }
                ]
            , row [ width fill, height fill ]
                [ el [ centerX ] <| text "hi" ]
            ]
