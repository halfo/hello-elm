module Update exposing (..)

import Array
import Random
import Keyboard
import Models exposing (..)
import Messages exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    if model.state == GameOver then
        model ! []
    else
        case msg of
            Tick time ->
                let
                    newHead =
                        getNewHead model.snake model.direction

                    state =
                        getNewState newHead

                    grown =
                        List.member model.fruit model.snake
                in
                    ( { model
                        | state = state
                        , snake =
                            case state of
                                Active ->
                                    newHead
                                        :: (if grown then
                                                model.snake
                                            else
                                                dropLast model.snake
                                           )

                                GameOver ->
                                    model.snake
                      }
                    , if grown then
                        Random.generate NewFruit
                            (Random.int 0
                                (board.row
                                    * board.column
                                    - (List.length model.snake + 1)
                                    - 1
                                )
                            )
                      else
                        Cmd.none
                    )

            KeyPress keyCode ->
                let
                    newDirection =
                        mapKeyCodeToDirection keyCode
                in
                    { model
                        | direction =
                            if validDirection model.direction newDirection then
                                newDirection
                            else
                                model.direction
                    }
                        ! []

            NewFruit idx ->
                let
                    restOfTheBoard =
                        List.filter
                            (\block -> not (List.member block model.snake))
                            (multiplyList
                                Block
                                (List.range 0 (board.row - 1))
                                (List.range 0 (board.column - 1))
                            )

                    maybeFruit =
                        Array.get idx (Array.fromList restOfTheBoard)

                    newFruit =
                        case maybeFruit of
                            Nothing ->
                                Block 0 0

                            Just block ->
                                block
                in
                    { model
                        | fruit = newFruit
                    }
                        ! []


multiplyList : (a -> b -> c) -> List a -> List b -> List c
multiplyList func x y =
    List.concatMap
        (\row ->
            List.map (\column -> func row column) y
        )
        x


getNewState : Block -> State
getNewState snakeHead =
    if
        snakeHead.x
            < 0
            || snakeHead.x
            >= board.column
            || snakeHead.y
            < 0
            || snakeHead.y
            >= board.row
    then
        GameOver
    else
        Active


validDirection : Direction -> Direction -> Bool
validDirection oldDirection newDirection =
    case oldDirection of
        Left ->
            newDirection /= Right

        Right ->
            newDirection /= Left

        Up ->
            newDirection /= Down

        Down ->
            newDirection /= Up

        None ->
            True


mapKeyCodeToDirection : Keyboard.KeyCode -> Direction
mapKeyCodeToDirection keyCode =
    case keyCode of
        37 ->
            Left

        39 ->
            Right

        38 ->
            Up

        40 ->
            Down

        _ ->
            None


moveBlock : Block -> Direction -> Block
moveBlock block direction =
    case direction of
        Left ->
            { block | x = block.x - 1 }

        Right ->
            { block | x = block.x + 1 }

        Up ->
            { block | y = block.y - 1 }

        Down ->
            { block | y = block.y + 1 }

        None ->
            block


dropLast : List a -> List a
dropLast list =
    let
        newLength =
            max ((List.length list) - 1) 0
    in
        List.take newLength list


getNewHead : List Block -> Direction -> Block
getNewHead snake direction =
    case List.head snake of
        Nothing ->
            Block 0 0

        Just snakeHead ->
            moveBlock snakeHead direction
