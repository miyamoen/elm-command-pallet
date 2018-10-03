module Molecule.Commands exposing (book, view)

import Bibliopola exposing (..)
import Bibliopola.Story as Story
import Command
import Element exposing (..)
import Element.Events exposing (onClick)
import Element.Font as Font exposing (..)
import Molecule.Command as Command
import SelectList exposing (Position(..), SelectList)
import Types exposing (Command, logMsg)


view : Maybe (SelectList (Command msg)) -> Element msg
view commands =
    Maybe.map whenJust commands
        |> Maybe.withDefault (el [ width fill ] <| text "no matches found")


whenJust : SelectList (Command msg) -> Element msg
whenJust commands =
    column [ spacing 4, width fill ] <|
        SelectList.mapBy Command.view commands


book : Book
book =
    intoBook "Commands" String.fromInt view
        |> addStory commandsStory
        |> buildBook


commandsStory : Story (Maybe (SelectList (Command Int)))
commandsStory =
    SelectList.selectAll Command.dummy
        |> Story.build "commands" (SelectList.selected >> .msg >> String.fromInt)
        |> Story.map Just
        |> Story.addOption "empty" Nothing


main : Bibliopola.Program
main =
    fromBook book
