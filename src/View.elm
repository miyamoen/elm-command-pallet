module View exposing (view)

import Bibliopola exposing (..)
import Bibliopola.Story as Story
import Element exposing (..)
import Types exposing (..)
import Update exposing (..)


view : (Msg -> msg) -> Model msg -> Element msg
view toMsg { isVisible, filtered } =
    if isVisible then
        column []
            [ text "text box"
            , case filtered of
                Nothing ->
                    text "empty"

                Just msgs ->
                    text "msgs"
            ]

    else
        text "Hidden"


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
