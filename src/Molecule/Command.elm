module Molecule.Command exposing (book, view)

import Bibliopola exposing (..)
import Bibliopola.Story as Story
import Command
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font exposing (..)
import Molecule.Fragments as Fragments
import SelectList exposing (Position(..), SelectList)
import Types exposing (Command, logMsg)


view : Position -> SelectList (Command msg) -> Element msg
view pos command =
    let
        { label, msg, fragments } =
            SelectList.selected command
    in
    el
        [ onClick msg
        , if pos == Selected then
            Background.color <| rgb255 155 160 180

          else
            regular
        , padding 8
        , Border.rounded 3
        , width fill
        ]
    <|
        Fragments.view fragments


book : Book
book =
    let
        view_ pos =
            view pos Command.dummy
    in
    intoBook "Command" String.fromInt view_
        |> addStory
            (Story "position"
                [ ( "selected", Selected )
                , ( "before", BeforeSelected )
                , ( "after", AfterSelected )
                ]
            )
        |> buildBook


main : Bibliopola.Program
main =
    fromBook book
