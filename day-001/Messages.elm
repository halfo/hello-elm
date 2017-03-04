module Messages exposing (..)

import Time
import Keyboard


type Msg
    = Tick Time.Time
    | KeyPress Keyboard.KeyCode
    | NewFruit Int
