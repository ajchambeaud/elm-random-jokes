module App.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import App.Types exposing (..)
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row
import Bootstrap.Grid.Col as Col
import Bootstrap.Button as Button
import Bootstrap.Alert as Alert
import RemoteData exposing (..)


jokeResult : WebData Joke -> Html Msg
jokeResult jokeData =
    case jokeData of
        Loading ->
            text "Loading..."

        Failure err ->
            Alert.danger [ text ("Error: " ++ toString err) ]

        Success joke ->
            text joke.desc

        _ ->
            text ""


fetchButton : WebData Joke -> Html Msg
fetchButton jokeData =
    case jokeData of
        Loading ->
            Button.button
                [ Button.primary, Button.attrs [ disabled True ] ]
                [ text "Fetch Random Joke" ]

        _ ->
            Button.button [ Button.primary, Button.attrs [ onClick GetRandomJoke ] ]
                [ text "Fetch Random Joke" ]


view : Model -> Html Msg
view model =
    Grid.containerFluid []
        [ Grid.row
            [ Row.centerXs ]
            [ Grid.col
                [ Col.xs12 ]
                [ fetchButton model.joke ]
            ]
        , Grid.row
            [ Row.centerXs ]
            [ Grid.col
                [ Col.xs12 ]
                [ div
                    [ class "joke-container" ]
                    [ jokeResult model.joke ]
                ]
            ]
        ]
