module Views exposing (..)

import Json.Encode as Encode
import Html exposing (..)
import Html.Attributes exposing (..)
import Models exposing (..)
import Messages exposing (..)


view : Model -> Html Msg
view model =
    div
        [ boardStyle
        , property "className" (Encode.string "board")
        ]
        (List.map
            (\isBackground -> blockView isBackground)
            (getBoardAsList (board.row * board.column) model)
        )


blockToIdx : Block -> Int
blockToIdx block =
    (block.y * board.column) + block.x


getBoardAsList : Int -> Model -> List Bool
getBoardAsList size model =
    let
        boardList =
            List.repeat size False

        snake =
            List.map blockToIdx model.snake

        fruit =
            blockToIdx model.fruit
    in
        List.indexedMap
            (\idx elem -> not ((List.member idx snake) || idx == fruit))
            boardList


blockView : Bool -> Html Msg
blockView isBackground =
    let
        color =
            if isBackground then
                "#bbada0"
            else
                "#ede0c8"
    in
        div [ blockStyle color ] []


boardStyle : Attribute Msg
boardStyle =
    style
        [ ( "position", "absolute" )
        , ( "width", "600px" )
        , ( "height", "600px" )
        , ( "z-index", "15" )
        , ( "top", "50%" )
        , ( "left", "50%" )
        , ( "margin", "-300px 0 0 -300px" )
        , ( "padding", "5px" )
        , ( "border-radius", "2px" )
        , ( "background", "#bbada0" )
          -- Flex Box
        , ( "display", "flex" )
        , ( "flex-wrap", "wrap" )
        , ( "justify-content", "flex-start" )
        ]


blockStyle : String -> Attribute Msg
blockStyle color =
    style
        [ ( "background", color )
        , ( "margin", "3px" )
        , ( "border-radius", "2px" )
        , ( "text-align", "center" )
        , ( "width", "54px" )
        , ( "height", "54px" )
        ]
