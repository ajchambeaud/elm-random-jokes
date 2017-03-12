module App.Rest exposing (..)

import Http exposing (..)
import Json.Decode exposing (string, int, at, Decoder)
import Json.Decode.Pipeline exposing (decode, requiredAt)
import App.Types exposing (..)
import RemoteData exposing (..)


jokeDecoder : Decoder Joke
jokeDecoder =
    decode Joke
        |> requiredAt [ "value", "id" ] int
        |> requiredAt [ "value", "joke" ] string


getJokesCmd : Cmd Msg
getJokesCmd =
    jokeDecoder
        |> Http.get "http://api.icndb.com/jokes/random"
        |> RemoteData.sendRequest
        |> Cmd.map JokeResponse
