module Main exposing (..)

import Window
import Task
import Random
import Html exposing (..)
import Mouse exposing (..)


-- MAIN


main : Program Never Model Msg
main =
    program
        { init = initialModel
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type Direction
    = Left
    | Right
    | Up
    | Down
    | None


type alias Model =
    { mouseX : Int
    , mouseY : Int
    , target : Direction
    }


initialModel : ( Model, Cmd Msg )
initialModel =
    ( Model 0 0 Left, Cmd.none )



-- MESSAGES


type Msg
    = OnMouseMove Mouse.Position
    | HasReachedDirection Window.Size
    | NewDirection Direction



-- UPDATE


mapIntToDirection : Int -> Direction
mapIntToDirection dirInt =
    if dirInt == 1 then
        Left
    else if dirInt == 2 then
        Right
    else if dirInt == 3 then
        Up
    else if dirInt == 4 then
        Down
    else
        None


inRange : Int -> Int -> Bool
inRange a b =
    let
        maxAllowedDistance =
            100
    in
        abs (a - b) <= maxAllowedDistance


getCurrentLocation : Model -> Window.Size -> Direction
getCurrentLocation model windowSize =
    let
        x =
            model.mouseX

        y =
            model.mouseY
    in
        if inRange x 0 then
            Left
        else if inRange x windowSize.width then
            Right
        else if inRange y 0 then
            Up
        else if inRange y windowSize.height then
            Down
        else
            None


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnMouseMove mousePosition ->
            ( { model
                | mouseX = mousePosition.x
                , mouseY = mousePosition.y
              }
            , Task.perform HasReachedDirection Window.size
            )

        HasReachedDirection windowSize ->
            let
                currentLocation =
                    getCurrentLocation model windowSize
            in
                if model.target == currentLocation then
                    ( model
                    , Random.generate
                        (\x -> NewDirection (mapIntToDirection x))
                        (Random.int 1 4)
                    )
                else
                    ( model, Cmd.none )

        NewDirection direction ->
            ( { model | target = direction }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    text <| toString model



-- SUBSCRIPTIONS


subscriptions : model -> Sub Msg
subscriptions model =
    Mouse.moves OnMouseMove
