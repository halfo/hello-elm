module Subscriptions exposing (..)

import Time
import Keyboard
import Models exposing (Model)
import Messages exposing (Msg(..))


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.ups KeyPress
        , Time.every (200 * Time.millisecond) Tick
        ]
