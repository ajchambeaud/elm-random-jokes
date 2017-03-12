module App.Types exposing (..)

import RemoteData exposing (..)


type alias Joke =
    { id : Int
    , desc : String
    }


type alias Model =
    { joke : WebData Joke
    }


type Msg
    = GetRandomJoke
    | JokeResponse (WebData Joke)
