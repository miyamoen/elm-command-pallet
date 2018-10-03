module View exposing (view)

import Atom.Frame as Frame
import Atom.Input as Input
import Bibliopola exposing (..)
import Bibliopola.Story as Story
import Element exposing (..)
import Molecule.Commands as Commands
import Types exposing (..)
import Update exposing (init, update)


view : Model msg -> Element msg
view { isVisible, filtered, filter, toMsg } =
    if isVisible then
        Frame.view toMsg
            [ Input.view filter |> Element.map toMsg
            , Commands.view filtered
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
