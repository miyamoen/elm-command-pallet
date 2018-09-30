module Organism.Input exposing (book, view)

import Bibliopola exposing (..)
import Bibliopola.Story as Story
import Element exposing (..)
import Element.Input as Input exposing (labelBelow)
import Html.Attributes exposing (id)
import Types exposing (Msg(..), inputId)
import Update exposing (logMsg)


view : String -> Element Msg
view filter =
    Input.text [ htmlAttribute <| id inputId ]
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
