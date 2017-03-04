module Models exposing (State(..), Direction(..), Block, Model, board, initialModel)


type State
    = Active
    | GameOver


type Direction
    = Left
    | Right
    | Up
    | Down
    | None


type alias Block =
    { x : Int
    , y : Int
    }


type alias Model =
    { snake : List Block
    , direction : Direction
    , fruit : Block
    , state : State
    }


board : { row : Int, column : Int }
board =
    { row = 10
    , column = 10
    }


initialFoodBlock : Block
initialFoodBlock =
    Block (board.row // 2) (board.column // 2)


initialBody : List Block
initialBody =
    let
        originX =
            0

        originY =
            board.row - 1
    in
        [ Block (originX + 2) originY
        , Block (originX + 1) originY
        , Block (originX) originY
        ]


initialModel : Model
initialModel =
    Model initialBody Right initialFoodBlock Active
