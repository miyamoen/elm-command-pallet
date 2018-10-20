module CommandPallet exposing
    ( Model, init
    , inFront, html
    , Msg, update
    , subscriptions, subscriptionsWithKey
    , showUpMsg
    )

{-| A command pallet component.


# Model

@docs Model, init


# View

@docs inFront, html


# Update

@docs Msg, update


# Startup

@docs subscriptions, subscriptionsWithKey
@docs showUpMsg

-}

import Element exposing (Attribute, Element, layout, none)
import Html exposing (Html)
import Keyboard.Key exposing (Key(..))
import Types
import Update
import View


{-| Contains a current state for a command pallet.
-}
type Model msg
    = CommandPallet (Types.Model msg)


{-| Needs to be passed to `update`.
-}
type alias Msg =
    Types.Msg


{-| Returns a new `Model` and a parent `Cmd msg`.
-}
update : Msg -> Model msg -> ( Model msg, Cmd msg )
update msg (CommandPallet model) =
    Update.update msg model
        |> Tuple.mapFirst CommandPallet


{-| Accepts Msg converter function and your commands.

    CommandPallet.init CommandPalletMsg
        [ ( "Increment", Increment )
        , ( "Decrement", Decrement )
        , ( "1", Set 1 )
        , ( "11", Set 11 )
        , ( "123", Set 123 )
        , ( "151", Set 151 )
        , ( "100", Set 100 )
        , ( "101", Set 101 )
        , ( "900", Set 900 )
        ]

-}
init : (Msg -> msg) -> List ( String, msg ) -> Model msg
init toMsg msgs =
    Update.init toMsg msgs
        |> CommandPallet


{-| View function with [elm-ui](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/).

    layout [ inFront <| CommandPallet.element model.commandPallet ] <|
        column [] [ text "your application..." ]

-}
element : Model msg -> Element msg
element (CommandPallet model) =
    View.view model


{-| `Attribute` in [elm-ui](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/).

Use like below:

    layout [ CommandPallet.inFront model.commandPallet ] <|
        column [] [ text "your application..." ]

-}
inFront : Model msg -> Attribute msg
inFront model =
    Element.inFront <| element model


{-| View function with `Html`
-}
html : Model msg -> Html msg
html model =
    layout [ inFront model ] none


{-| Subsciption for startup key, `p`.
-}
subscriptions : Model msg -> Sub msg
subscriptions (CommandPallet model) =
    Update.subscriptions model


{-| Customizable subsciption for startup key.

`Key` type is in [SwiftsNamesake/proper-keyboard](https://package.elm-lang.org/packages/SwiftsNamesake/proper-keyboard/4.0.0).

-}
subscriptionsWithKey : Key -> Model msg -> Sub msg
subscriptionsWithKey key (CommandPallet model) =
    Update.subscriptionsWithKey key model


{-| Use `showUpMsg` in your application and customize command pallet startup.
-}
showUpMsg : Msg
showUpMsg =
    Types.ShowUp
