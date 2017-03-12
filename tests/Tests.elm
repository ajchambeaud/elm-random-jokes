module Tests exposing (..)

import Json.Decode exposing (decodeString)
import RemoteData exposing (..)
import Test exposing (..)
import Html exposing (..)
import Http exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Expect
import App.Rest exposing (..)
import App.Types exposing (..)
import App.State exposing (..)
import App.View exposing (..)


sampleJoke : String
sampleJoke =
    "{ \"type\": \"success\", \"value\": { \"id\": 268, \"joke\": \"Time waits for no man. Unless that man is Chuck Norris.\" } }"


successView : Html Msg
successView =
    div [ class "container-fluid" ]
        [ div [ class "row justify-content-center" ]
            [ div [ class "col-12" ]
                [ button [ class "btn btn-primary", disabled False, onClick GetRandomJoke ]
                    [ text "Fetch Random Joke" ]
                ]
            ]
        , div [ class "row justify-content-center" ]
            [ div [ class "col-12" ]
                [ div [ class "joke-container" ]
                    [ text "test" ]
                ]
            ]
        ]


loadingView : Html Msg
loadingView =
    div [ class "container-fluid" ]
        [ div [ class "row justify-content-center" ]
            [ div [ class "col-12" ]
                [ button [ class "btn btn-primary", disabled True ]
                    [ text "Fetch Random Joke" ]
                ]
            ]
        , div [ class "row justify-content-center" ]
            [ div [ class "col-12" ]
                [ div [ class "joke-container" ]
                    [ text "Loading..." ]
                ]
            ]
        ]


errorView : Html Msg
errorView =
    div [ class "container-fluid" ]
        [ div [ class "row justify-content-center" ]
            [ div [ class "col-12" ]
                [ button [ class "btn btn-primary", disabled False, onClick GetRandomJoke ]
                    [ text "Fetch Random Joke" ]
                ]
            ]
        , div [ class "row justify-content-center" ]
            [ div [ class "col-12" ]
                [ div [ class "joke-container" ]
                    [ div [ class "alert alert-danger" ]
                        [ text "Error: NetworkError" ]
                    ]
                ]
            ]
        ]


restModule : Test
restModule =
    describe "Rest module test suite"
        [ test "App.Rest.jokeDecoder should decode a joke" <|
            \() ->
                Expect.equal
                    (decodeString App.Rest.jokeDecoder sampleJoke)
                    (Ok (Joke 268 "Time waits for no man. Unless that man is Chuck Norris."))
        ]


stateModule : Test
stateModule =
    describe "State module test suite"
        [ test "App.State.init should set getJokesCmd as a default command" <|
            \() ->
                Expect.equal (Tuple.second App.State.init) (App.Rest.getJokesCmd)
        , test "App.State.init joke initial value should be NotAsked" <|
            \() ->
                Expect.equal (.joke (Tuple.first App.State.init)) (NotAsked)
        , test "App.State.update when a GetRandomJoke message is received, joke must be set to Loading" <|
            \() ->
                App.State.init
                    |> Tuple.first
                    |> App.State.update GetRandomJoke
                    |> Tuple.first
                    |> .joke
                    |> Expect.equal Loading
        , test "App.State.update when a JokeResponse message is received, the function must return Cmd.none" <|
            \() ->
                App.State.init
                    |> Tuple.first
                    |> App.State.update (JokeResponse (Success (Joke 268 "test")))
                    |> Tuple.second
                    |> Expect.equal Cmd.none
        ]


viewModule : Test
viewModule =
    describe "State module test suite"
        [ test "App.State.view should return the error view when there whas an error in the response" <|
            \() ->
                App.State.init
                    |> Tuple.first
                    |> App.State.update (JokeResponse (Failure NetworkError))
                    |> Tuple.first
                    |> App.View.view
                    |> Expect.equal errorView
        , test "App.State.view should return the sucess view when there whas an sucess response" <|
            \() ->
                App.State.init
                    |> Tuple.first
                    |> App.State.update (JokeResponse (Success <| Joke 268 "test"))
                    |> Tuple.first
                    |> App.View.view
                    |> Expect.equal successView
        , test "App.State.view should return the loading view when the response is loading" <|
            \() ->
                App.State.init
                    |> Tuple.first
                    |> App.State.update GetRandomJoke
                    |> Tuple.first
                    |> App.View.view
                    |> Expect.equal loadingView
        ]


all : Test
all =
    describe "A Test Suite"
        [ restModule
        , stateModule
        , viewModule
        ]
