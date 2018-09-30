module View exposing (view)

import Bibliopola exposing (..)
import Bibliopola.Story as Story
import Element exposing (..)
import Element.Background as Background
import Organism.Input as Input
import SelectList exposing (Position(..))
import Types exposing (..)
import Update exposing (..)


view : Model msg -> Element msg
view { isVisible, filtered, filter, toMsg } =
    if isVisible then
        column
            [ explain Debug.todo
            , width fill
            , height <| fill
            , paddingXY 24 40
            ]
            [ Input.view filter |> Element.map toMsg
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
                        |> init logMsg
            in
            view <|
                if isVisible then
                    update ShowUp model
                        |> Tuple.first

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
