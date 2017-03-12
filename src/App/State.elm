module App.State exposing (..)

import App.Rest exposing (..)
import App.Types exposing (..)
import RemoteData exposing (..)


init : ( Model, Cmd Msg )
init =
    ( { joke = NotAsked
      }
    , getJokesCmd
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetRandomJoke ->
            ( { model | joke = Loading }, getJokesCmd )

        JokeResponse res ->
            ( { model | joke = res }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
