module Atom.Input exposing (book, view)

import Bibliopola exposing (..)
import Bibliopola.Story as Story
import Element exposing (..)
import Element.Font as Font
import Element.Input as Input exposing (labelBelow)
import Html.Attributes exposing (id)
import Types exposing (Msg(..), inputId, logMsg)


view : String -> Element Msg
view filter =
    Input.text
        [ htmlAttribute <| id inputId
        , Font.color <| rgb255 74 74 89
        ]
        { onChange = Input
        , text = filter
        , placeholder = Nothing
        , label = labelBelow [] none
        }


book : Book
book =
    intoBook "Input" logMsg view
        |> addStory
            (Story.build "value" identity [ "spam spam", "spam egg ham" ])
        |> buildBook


main : Bibliopola.Program
main =
    fromBook book
