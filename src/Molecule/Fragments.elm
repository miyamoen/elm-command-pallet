module Molecule.Fragments exposing (book, view)

import Atom.Fragment as Fragment
import Bibliopola exposing (..)
import Bibliopola.Story as Story
import Element exposing (..)
import Types exposing (Fragment, logMsg)


view : List Fragment -> Element msg
view fragments =
    paragraph [] <| List.map Fragment.view fragments


book : Book
book =
    let
        view_ spam egg ham =
            view
                [ { text = "spam", matched = spam }
                , { text = "egg", matched = egg }
                , { text = "ham", matched = ham }
                ]
    in
    intoBook "Fragments" logMsg view_
        |> addStory (Story.bool "spam")
        |> addStory (Story.bool "egg")
        |> addStory (Story.bool "ham")
        |> buildBook


main : Bibliopola.Program
main =
    fromBook book
