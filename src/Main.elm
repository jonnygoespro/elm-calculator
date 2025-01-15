module Main exposing (Msg(..), main, update, view)

import Browser
import Browser.Events exposing (onKeyDown)
import Html exposing (Html, button, div, p, text)
import Html.Attributes as Attr exposing (class, id, tabindex)
import Html.Events exposing (onClick)
import Json.Decode as Decode


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( init, Cmd.none )
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { output : Result String Int
    , operator : String
    , firstNumber : Int
    }


init : Model
init =
    { output = Ok 0
    , operator = ""
    , firstNumber = 0
    }



-- UPDATE


type Msg
    = NumberButtonClicked Int
    | ClearButtonClicked
    | PlusButtonClicked
    | MinusButtonClicked
    | MultiplyButtonClicked
    | DivideButtonClicked
    | EqualSignButtonClicked
    | KeyPressed String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NumberButtonClicked newNumber ->
            case model.output of
                Ok currentOutput ->
                    if model.operator /= "=" then
                        ( { model | output = checkOverflow (currentOutput * 10 + newNumber) }, Cmd.none )

                    else
                        ( { model | output = Ok newNumber, firstNumber = 0, operator = "" }, Cmd.none )

                Err _ ->
                    ( { model | output = Ok newNumber, firstNumber = 0, operator = "" }, Cmd.none )

        ClearButtonClicked ->
            ( { model | output = Ok 0, firstNumber = 0, operator = "" }, Cmd.none )

        PlusButtonClicked ->
            ( handleOperator model "+", Cmd.none )

        MinusButtonClicked ->
            ( handleOperator model "-", Cmd.none )

        MultiplyButtonClicked ->
            ( handleOperator model "*", Cmd.none )

        DivideButtonClicked ->
            ( handleOperator model "/", Cmd.none )

        EqualSignButtonClicked ->
            case model.output of
                Ok currentOutput ->
                    let
                        result =
                            calculate model.firstNumber model.operator currentOutput
                    in
                    ( { model | output = result, firstNumber = extractResult result, operator = "=" }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        KeyPressed key ->
            case key of
                "0" ->
                    update (NumberButtonClicked 0) model

                "1" ->
                    update (NumberButtonClicked 1) model

                "2" ->
                    update (NumberButtonClicked 2) model

                "3" ->
                    update (NumberButtonClicked 3) model

                "4" ->
                    update (NumberButtonClicked 4) model

                "5" ->
                    update (NumberButtonClicked 5) model

                "6" ->
                    update (NumberButtonClicked 6) model

                "7" ->
                    update (NumberButtonClicked 7) model

                "8" ->
                    update (NumberButtonClicked 8) model

                "9" ->
                    update (NumberButtonClicked 9) model

                "+" ->
                    update PlusButtonClicked model

                "-" ->
                    update MinusButtonClicked model

                "*" ->
                    update MultiplyButtonClicked model

                "/" ->
                    update DivideButtonClicked model

                "Enter" ->
                    update EqualSignButtonClicked model

                "c" ->
                    update ClearButtonClicked model

                _ ->
                    ( model, Cmd.none )


handleOperator : Model -> String -> Model
handleOperator model operator =
    case model.output of
        Ok currentOutput ->
            { model | firstNumber = currentOutput, operator = operator, output = Ok 0 }

        Err _ ->
            model


calculate : Int -> String -> Int -> Result String Int
calculate firstNumber operator secondNumber =
    case operator of
        "+" ->
            checkOverflow (firstNumber + secondNumber)

        "-" ->
            checkOverflow (firstNumber - secondNumber)

        "*" ->
            checkOverflow (firstNumber * secondNumber)

        "/" ->
            if secondNumber == 0 then
                Err "Cannot Divide by zero"

            else
                checkOverflow (firstNumber // secondNumber)

        _ ->
            Err "Invalid Operation"


extractResult : Result String Int -> Int
extractResult result =
    case result of
        Ok value ->
            value

        Err _ ->
            0


checkOverflow : Int -> Result String Int
checkOverflow number =
    if number < -2147483648 || number > 2147483647 then
        Err "Overflow occured"

    else
        Ok number



-- VIEW


view : Model -> Html Msg
view model =
    div [ id "calculator", Attr.tabindex 0 ]
        [ p [ class "output" ] [ text (displayOutput model) ]
        , div [ class "actions" ]
            [ button [ onClick (NumberButtonClicked 7) ] [ text "7" ]
            , button [ onClick (NumberButtonClicked 8) ] [ text "8" ]
            , button [ onClick (NumberButtonClicked 9) ] [ text "9" ]
            , button [ class "actionButton", onClick PlusButtonClicked ] [ text "+" ]
            , button [ onClick (NumberButtonClicked 4) ] [ text "4" ]
            , button [ onClick (NumberButtonClicked 5) ] [ text "5" ]
            , button [ onClick (NumberButtonClicked 6) ] [ text "6" ]
            , button [ class "actionButton", onClick MinusButtonClicked ] [ text "-" ]
            , button [ onClick (NumberButtonClicked 1) ] [ text "1" ]
            , button [ onClick (NumberButtonClicked 2) ] [ text "2" ]
            , button [ onClick (NumberButtonClicked 3) ] [ text "3" ]
            , button [ class "actionButton", onClick MultiplyButtonClicked ] [ text "*" ]
            , button [ onClick ClearButtonClicked ] [ text "c" ]
            , button [ onClick (NumberButtonClicked 0) ] [ text "0" ]
            , button [ class "actionButton", onClick EqualSignButtonClicked ] [ text "=" ]
            , button [ class "actionButton", onClick DivideButtonClicked ] [ text "/" ]
            ]
        ]


displayOutput : Model -> String
displayOutput model =
    case model.output of
        Ok output ->
            case model.firstNumber of
                0 ->
                    String.fromInt output

                _ ->
                    case model.operator of
                        "=" ->
                            String.fromInt output

                        _ ->
                            String.fromInt model.firstNumber ++ " " ++ model.operator ++ " " ++ String.fromInt output

        Err errorMessage ->
            errorMessage



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    onKeyDown (Decode.map KeyPressed (Decode.field "key" Decode.string))
