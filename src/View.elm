module View exposing (view)

import Bibliopola exposing (..)
import Bibliopola.Story as Story
import Element exposing (..)
import Element.Background as Background
import SelectList exposing (Position(..))
import Types exposing (..)
import Update exposing (..)


view : (Msg -> msg) -> Model msg -> Element msg
view toMsg { isVisible, filtered } =
    if isVisible then
        column []
            [ text "text box"
            , column [] <|
                case filtered of
                    Nothing ->
                        [ text "empty" ]

                    Just msgs ->
                        SelectList.mapBy
                            (\pos selected ->
                                el
                                    [ Background.color <|
                                        case pos of
                                            Selected ->
                                                rgba255 56 154 94 0.76

                                            _ ->
                                                rgba255 144 144 144 0.69
                                    ]
                                <|
                                    text <|
                                        Tuple.first <|
                                            SelectList.selected selected
                            )
                            msgs
            ]

    else
        none


book : Book
book =
    let
        view_ isVisible msgs =
            let
                model =
                    List.map (\msg -> ( msg, msg )) msgs
                        |> init
            in
            view logMsg <|
                if isVisible then
                    update ShowUp model

                else
                    model
    in
    intoBook "CommandPallet" identity view_
        |> addStory (Story.bool "isVisible")
        |> addStory
            (Story "msgs"
                [ ( "empty", [] )
                , ( "one", [ "first" ] )
                , ( "two", [ "first", "second" ] )
                , ( "three", [ "first", "second", "third" ] )
                ]
            )
        |> buildBook
        |> withFrontCover
            (view_ True [ "first" ])


main : Bibliopola.Program
main =
    fromBook book
