module Command exposing (divide, downCursor, dummy, filter, init, match, upCursor)

import SelectList exposing (SelectList)
import Set.Any as Set
import Simple.Fuzzy as Fuzzy
import Types exposing (..)


filter : String -> List (Command msg) -> Filtered msg
filter query commands =
    let
        partialMatched =
            partialFilter query commands

        fuzzyMatched =
            fuzzyFilter query
                (Set.fromList .index commands
                    |> (\original ->
                            Set.diff original <| Set.fromList .index partialMatched
                       )
                    |> Set.toList
                )
    in
    SelectList.fromList
        (partialMatched ++ fuzzyMatched)


partialFilter : String -> List (Command msg) -> List (Command msg)
partialFilter query commands =
    List.filterMap (match query) commands


fuzzyFilter : String -> List (Command msg) -> List (Command msg)
fuzzyFilter query commands =
    Fuzzy.filter .label query commands


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


init : Int -> String -> msg -> Command msg
init index label msg =
    { label = label
    , msg = msg
    , fragments = [ { text = label, matched = False } ]
    , index = index
    }


upCursor : SelectList (Command msg) -> SelectList (Command msg)
upCursor commands =
    SelectList.selectWhileLoopBy -1 commands


downCursor : SelectList (Command msg) -> SelectList (Command msg)
downCursor commands =
    SelectList.selectWhileLoopBy 1 commands


dummy : SelectList (Command Int)
dummy =
    SelectList.fromLists
        [ init 0 "one" 1, init 1 "two" 2 ]
        (init 2 "three" 3)
        [ init 3 "four" 4, init 4 "five" 5, init 5 "six" 6 ]
