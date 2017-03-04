module Main exposing (..)

import Html exposing (..)
import Models exposing (Model, initialModel)
import Messages exposing (Msg)
import Views exposing (view)
import Update exposing (update)
import Subscriptions exposing (subscriptions)


main : Program Never Model Msg
main =
    program
        { init = initialModel ! []
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
