module Molecule.Commands exposing (book, view)

import Bibliopola exposing (..)
import Bibliopola.Story as Story
import Command
import Element exposing (..)
import Element.Events exposing (onClick)
import Element.Font as Font exposing (..)
import Molecule.Command as Command
import SelectList exposing (SelectList)
import Types exposing (..)


view : (Msg -> msg) -> Maybe (SelectList (Command msg)) -> Element msg
view toMsg commands =
    Maybe.map (whenJust toMsg) commands
        |> Maybe.withDefault (el [ width fill ] <| text "no matches found")


whenJust : (Msg -> msg) -> SelectList (Command msg) -> Element msg
whenJust toMsg commands =
    column [ width fill, onClick <| toMsg Close ] <|
        SelectList.mapBy Command.view commands


book : Book
book =
    intoBook "Commands" String.fromInt (view (always 999))
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
