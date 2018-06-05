module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Random


type alias Model =
    { dieFace : Int
    , dieFace2 : Int
    }


type Msg
    = Roll
    | NewFace Int
    | NewFace2 Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model
            , Cmd.batch
                [ -- This is evaluated as a Cmd Msg.
                  Random.generate
                    -- This is (a -> msg).
                    NewFace
                    -- This returns a Generator Int.
                    (Random.int 1 6)
                , -- This is evaluated as a Cmd Msg.
                  Random.generate
                    -- This is (a -> msg).
                    NewFace2
                    -- This returns a Generator Int.
                    (Random.int 1 6)
                ]
            )

        NewFace newFace ->
            ( { model | dieFace = newFace }, Cmd.none )

        NewFace2 newFace ->
            ( { model | dieFace2 = newFace }, Cmd.none )


isEven : Int -> Bool
isEven num =
    num % 2 == 0


getXForNum : Int -> Int
getXForNum num =
    case num of
        1 ->
            0

        2 ->
            1

        3 ->
            2

        4 ->
            2

        5 ->
            1

        6 ->
            0

        _ ->
            0


getYForNum : Int -> Int
getYForNum num =
    if num < 4 then
        0
    else
        1


getPositionString : Int -> (Int -> Int) -> Int -> String
getPositionString size unitFinder value =
    toString (-size * unitFinder value) ++ "px"


getBackgroundX : Int -> ( String, String )
getBackgroundX value =
    let
        width =
            130
    in
    ( "backgroundPositionX", getPositionString width getXForNum value )


getBackgroundY : Int -> ( String, String )
getBackgroundY value =
    let
        height =
            130
    in
    ( "backgroundPositionY", getPositionString height getYForNum value )


dieView : Int -> Html Msg
dieView faceValue =
    div
        [ style
            [ ( "backgroundImage"
              , "url(https://upload.wikimedia.org/wikipedia/commons/e/ec/Kismet_Die_Faces.png)"
              )
            , ( "width", "130px" )
            , ( "height", "130px" )
            , getBackgroundX faceValue
            , getBackgroundY faceValue
            ]
        ]
        [ text (toString faceValue) ]


view : Model -> Html Msg
view model =
    div []
        [ dieView model.dieFace
        , dieView model.dieFace2
        , button [ onClick Roll ] [ text "Roll" ]
        ]


init : ( Model, Cmd Msg )
init =
    ( Model 1 1, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
