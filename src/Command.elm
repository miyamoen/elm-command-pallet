module Command exposing (divide, downCursor, dummy, filter, init, match, upCursor)

import SelectList exposing (Direction(..), SelectList)
import Types exposing (..)


filter : String -> List (Command msg) -> Filtered msg
filter query commands =
    List.filterMap (match query) commands
        |> SelectList.fromList


match : String -> Command msg -> Maybe (Command msg)
match query ({ label } as command) =
    String.indexes (String.toLower query) (String.toLower label)
        |> List.head
        |> Maybe.map
            (\index ->
                { command
                    | fragments = divide index (String.length query + index) label
                }
            )


divide : Int -> Int -> String -> List Fragment
divide start last label =
    [ Fragment (String.left start label) False
    , Fragment (String.slice start last label) True
    , Fragment (String.slice last (String.length label) label) False
    ]


init : String -> msg -> Command msg
init label msg =
    { label = label
    , msg = msg
    , fragments = [ { text = label, matched = False } ]
    }


upCursor : SelectList (Command msg) -> SelectList (Command msg)
upCursor commands =
    SelectList.changePosition Before 1 commands
        |> Maybe.withDefault (SelectList.changePositionToEnd After commands)


downCursor : SelectList (Command msg) -> SelectList (Command msg)
downCursor commands =
    SelectList.changePosition After 1 commands
        |> Maybe.withDefault (SelectList.changePositionToEnd Before commands)


dummy : SelectList (Command Int)
dummy =
    SelectList.fromLists
        [ init "one" 1, init "two" 2 ]
        (init "three" 3)
        [ init "four" 4, init "five" 5, init "six" 6 ]
