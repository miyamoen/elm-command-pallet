module View exposing (view)

import Bibliopola exposing (..)
import Bibliopola.Story as Story
import Element exposing (..)
import Types exposing (..)
import Update exposing (init, logMsg)


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
    bookWithFrontCover "CommandPallet"
        (view logMsg <| init [ ( "first", "first" ) ])


main : Bibliopola.Program
main =
    fromBook book
