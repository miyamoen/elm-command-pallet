module Atom.Frame exposing (view)

import Bibliopola exposing (..)
import Bibliopola.Story as Story
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Html.Events exposing (stopPropagationOn)
import Json.Decode as Decode
import Types exposing (..)


view : (Msg -> msg) -> List (Element msg) -> Element msg
view toMsg children =
    el
        [ width fill
        , height <| fill
        , paddingXY 24 40
        , Background.color <| rgba255 110 115 135 0.5
        , onClick <| toMsg Close
        ]
    <|
        column
            [ width (fill |> maximum 500)
            , centerX
            , padding 8
            , spacing 8
            , Background.color <| rgba255 110 115 135 1
            , Border.rounded 3
            , mapAttribute toMsg clickCancel
            ]
            children


clickCancel : Attribute Msg
clickCancel =
    htmlAttribute <|
        stopPropagationOn "click" <|
            Decode.succeed ( NoOp, True )


book : Book
book =
    intoBook "Frame" identity (view logMsg)
        |> addStory
            (Story "chirdren"
                [ ( "empty", [] )
                , ( "one", [ text "first" ] )
                , ( "two", [ text "first", text "second" ] )
                , ( "three", [ text "first", text "second", text "third" ] )
                ]
            )
        |> buildBook
        |> withFrontCover
            (view logMsg [ text "first" ])


main : Bibliopola.Program
main =
    fromBook book
