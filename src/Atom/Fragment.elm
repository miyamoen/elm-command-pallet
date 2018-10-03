module Atom.Fragment exposing (book, view)

import Bibliopola exposing (..)
import Bibliopola.Story as Story
import Element exposing (..)
import Element.Font as Font exposing (..)
import Types exposing (Fragment, logMsg)


view : Fragment -> Element msg
view { text, matched } =
    el
        [ if matched then
            bold

          else
            regular
        ]
    <|
        Element.text text


book : Book
book =
    let
        view_ text matched =
            view { text = text, matched = matched }
    in
    intoBook "Fragment" logMsg view_
        |> addStory
            (Story "text"
                [ ( "spam1", "spam spam" )
                , ( "spam2", "spam egg ham" )
                , ( "empty", "" )
                ]
            )
        |> addStory (Story.bool "matched")
        |> buildBook


main : Bibliopola.Program
main =
    fromBook book
