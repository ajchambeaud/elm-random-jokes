module Main exposing (..)

import App.Types exposing (..)
import App.State exposing (..)
import App.Rest exposing (..)
import App.View exposing (..)
import Html exposing (program)


main : Program Never Model Msg
main =
    program { view = view, init = init, update = update, subscriptions = subscriptions }
