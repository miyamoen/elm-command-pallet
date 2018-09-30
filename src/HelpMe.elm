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
            CP.init
                [ Tuple.pair "Increment" Increment
                , Tuple.pair "Decrement" Decrement
                ]
      }
    , Cmd.none
    )


type Msg
    = NoOp
    | Increment
    | Decrement
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

        CommandPalletMsg subMsg ->
            Tuple.pair
                { model
                    | commandPallet =
                        CP.update subMsg model.commandPallet
                }
                Cmd.none


subscriptions : Model -> Sub Msg
subscriptions { commandPallet } =
    CP.subscriptions CommandPalletMsg commandPallet


view : Model -> Html Msg
view { num, commandPallet } =
    layout [] <|
        column [ width fill ]
            [ row [ width fill, spacing 5 ]
                [ button [ centerX ]
                    { onPress = Just Decrement, label = el [] <| text "<" }
                , el [ centerX ] <| text <| String.fromInt num
                , button [ centerX ]
                    { onPress = Just Increment, label = el [] <| text ">" }
                ]
            , CP.view CommandPalletMsg commandPallet
            ]
