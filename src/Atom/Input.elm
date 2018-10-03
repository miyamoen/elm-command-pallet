module Atom.Input exposing (book, view)

import Bibliopola exposing (..)
import Bibliopola.Story as Story
import Element exposing (..)
import Element.Font as Font
import Element.Input as Input exposing (labelBelow)
import Html.Attributes exposing (id)
import Html.Events
import Keyboard.Event exposing (considerKeyboardEvent)
import Keyboard.Key exposing (Key(..))
import Types exposing (Msg(..), inputId, logMsg)


view : String -> Element Msg
view filter =
    Input.text
        [ htmlAttribute <| id inputId
        , Font.color <| rgb255 74 74 89
        , onKeyDown
        ]
        { onChange = Input
        , text = filter
        , placeholder = Nothing
        , label = labelBelow [] none
        }


onKeyDown : Attribute Msg
onKeyDown =
    htmlAttribute <|
        Html.Events.custom "keydown" <|
            considerKeyboardEvent
                (\{ keyCode } ->
                    case keyCode of
                        Enter ->
                            Just <| message Confirm

                        Escape ->
                            Just <| message Close

                        _ ->
                            Nothing
                )


message : Msg -> { message : Msg, stopPropagation : Bool, preventDefault : Bool }
message msg =
    { message = msg, stopPropagation = True, preventDefault = True }


book : Book
book =
    intoBook "Input" logMsg view
        |> addStory
            (Story.build "value" identity [ "spam spam", "spam egg ham" ])
        |> buildBook


main : Bibliopola.Program
main =
    fromBook book
