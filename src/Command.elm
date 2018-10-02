module Command exposing (divide, filter, init, match)

import SelectList exposing (SelectList)
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
