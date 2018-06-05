module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Random


type alias Model =
    { dieFace : Int
    }


type Msg
    = Roll
    | NewFace Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model
            , -- This is evaluated as a Cmd Msg.
              Random.generate
                -- This is (a -> msg).
                NewFace
                -- This returns a Generator Int.
                (Random.int 1 6)
            )

        NewFace newFace ->
            ( Model newFace, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text (toString model.dieFace) ]
        , button [ onClick Roll ] [ text "Roll" ]
        ]


init : ( Model, Cmd Msg )
init =
    ( Model 1, Cmd.none )


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
