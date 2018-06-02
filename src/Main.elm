module Main exposing (main)

import Browser
import CommandPallet as CP exposing (CommandPallet)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)



-- MAIN


main : Program () Model Msg
main =
    Browser.embed
        { init = init
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }



-- MODEL


type alias Model =
    { count : Int
    , selected : String
    , pallet : CommandPallet Msg
    }


init : flags -> ( Model, Cmd Msg )
init _ =
    ( { count = 0
      , selected = "No Selected"
      , pallet =
            CP.init
                [ ( "A", A )
                , ( "B", B )
                , ( "C", C )
                , ( "D", D )
                , ( "Increment", Increment )
                , ( "Decrement", Decrement )
                ]
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Increment
    | Decrement
    | A
    | B
    | C
    | D
    | CPMsg (CP.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            Tuple.pair { model | count = model.count + 1, selected = "Increment" }
                Cmd.none

        Decrement ->
            Tuple.pair { model | count = model.count - 1, selected = "Decrement" }
                Cmd.none

        A ->
            Tuple.pair { model | selected = "A" }
                Cmd.none

        B ->
            Tuple.pair { model | selected = "B" }
                Cmd.none

        C ->
            Tuple.pair { model | selected = "C" }
                Cmd.none

        D ->
            Tuple.pair { model | selected = "D" }
                Cmd.none

        CPMsg cpMsg ->
            let
                ( cp, cmd ) =
                    CP.update cpMsg model.pallet
            in
            Tuple.pair { model | pallet = cp }
                cmd



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text model.selected ]
        , button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model.count) ]
        , button [ onClick Increment ] [ text "+" ]
        , Html.map CPMsg <| CP.view model.pallet
        ]
