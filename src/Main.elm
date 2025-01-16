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
    { output : Result String String
    , operator : String
    , firstNumber : Float
    , secondNumber : Float
    , currentNumberString : String
    }


init : Model
init =
    { output = Ok "0"
    , operator = ""
    , firstNumber = 0
    , secondNumber = 0
    , currentNumberString = "0"
    }



-- UPDATE


type Msg
    = NumberButtonClicked Int
    | ClearButtonClicked
    | OperatorButtonClicked String
    | EqualSignButtonClicked
    | DeleteButtonPressed
    | CommaButtonPressed
    | KeyPressed String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NumberButtonClicked digit ->
            let
                newNumberString =
                    appendDigitToNumber model.currentNumberString (String.fromInt digit)
            in
            ( { model | currentNumberString = newNumberString, output = Ok newNumberString }, Cmd.none )

        ClearButtonClicked ->
            ( { model | output = Ok "0", firstNumber = 0, secondNumber = 0, operator = "", currentNumberString = "0" }, Cmd.none )

        OperatorButtonClicked operator ->
            let
                firstNumber =
                    String.toFloat model.currentNumberString |> Maybe.withDefault 0
            in
            ( { model | firstNumber = firstNumber, operator = operator, currentNumberString = "", output = Ok (String.fromFloat firstNumber ++ " " ++ operator) }, Cmd.none )

        DeleteButtonPressed ->
            let
                newNumberString =
                    case String.length model.currentNumberString of
                        0 ->
                            "0"

                        _ ->
                            String.slice 0 (String.length model.currentNumberString - 1) model.currentNumberString
            in
            ( { model | currentNumberString = newNumberString, output = Ok newNumberString }, Cmd.none )

        EqualSignButtonClicked ->
            let
                secondNumber =
                    String.toFloat model.currentNumberString |> Maybe.withDefault 0

                result =
                    calculate model.firstNumber model.operator secondNumber
            in
            case result of
                Ok value ->
                    ( { model | output = Ok (String.fromFloat value), firstNumber = value, secondNumber = 0, operator = "=", currentNumberString = String.fromFloat value }, Cmd.none )

                Err errorMessage ->
                    ( { model | output = Err errorMessage, firstNumber = 0, secondNumber = 0, operator = "", currentNumberString = "0" }, Cmd.none )

        CommaButtonPressed ->
            if String.contains "." model.currentNumberString then
                ( model, Cmd.none )

            else
                ( { model | currentNumberString = model.currentNumberString ++ ".", output = Ok (model.currentNumberString ++ ".") }, Cmd.none )

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
                    update (OperatorButtonClicked "+") model

                "-" ->
                    update (OperatorButtonClicked "-") model

                "*" ->
                    update (OperatorButtonClicked "*") model

                "/" ->
                    update (OperatorButtonClicked "/") model

                "." ->
                    update CommaButtonPressed model

                "," ->
                    update CommaButtonPressed model

                "Enter" ->
                    update EqualSignButtonClicked model

                "c" ->
                    update ClearButtonClicked model

                "Backspace" ->
                    update DeleteButtonPressed model

                _ ->
                    ( model, Cmd.none )


appendDigitToNumber : String -> String -> String
appendDigitToNumber currentNumber digit =
    if currentNumber == "0" && digit /= "." then
        digit

    else
        currentNumber ++ digit


calculate : Float -> String -> Float -> Result String Float
calculate firstNumber operator secondNumber =
    case operator of
        "+" ->
            Ok (firstNumber + secondNumber)

        "-" ->
            Ok (firstNumber - secondNumber)

        "*" ->
            Ok (firstNumber * secondNumber)

        "/" ->
            if secondNumber == 0 then
                Err "Cannot divide by zero"

            else
                Ok (firstNumber / secondNumber)

        _ ->
            Err "Invalid operation"



-- VIEW


view : Model -> Html Msg
view model =
    div [ id "calculator", Attr.tabindex 0 ]
        [ p [ class "output" ] [ text (displayOutput model) ]
        , div [ class "actions" ]
            [ button [ onClick ClearButtonClicked ] [ text "c" ]
            , button [ onClick (OperatorButtonClicked "%") ] [ text "%" ]
            , button [ onClick DeleteButtonPressed ] [ text "del" ]
            , button [ class "actionButton", onClick (OperatorButtonClicked "+") ] [ text "+" ]
            , button [ onClick (NumberButtonClicked 7) ] [ text "7" ]
            , button [ onClick (NumberButtonClicked 8) ] [ text "8" ]
            , button [ onClick (NumberButtonClicked 9) ] [ text "9" ]
            , button [ class "actionButton", onClick (OperatorButtonClicked "-") ] [ text "-" ]
            , button [ onClick (NumberButtonClicked 4) ] [ text "4" ]
            , button [ onClick (NumberButtonClicked 5) ] [ text "5" ]
            , button [ onClick (NumberButtonClicked 6) ] [ text "6" ]
            , button [ class "actionButton", onClick (OperatorButtonClicked "*") ] [ text "*" ]
            , button [ onClick (NumberButtonClicked 1) ] [ text "1" ]
            , button [ onClick (NumberButtonClicked 2) ] [ text "2" ]
            , button [ onClick (NumberButtonClicked 3) ] [ text "3" ]
            , button [ class "actionButton", onClick (OperatorButtonClicked "/") ] [ text "/" ]
            , button [ class "button0", onClick (NumberButtonClicked 0) ] [ text "0" ]
            , button [ onClick CommaButtonPressed ] [ text "," ]
            , button [ class "actionButton", onClick EqualSignButtonClicked ] [ text "=" ]
            ]
        ]


displayOutput : Model -> String
displayOutput model =
    let
        _ =
            Debug.log "model" model
    in
    case model.output of
        Ok output ->
            case model.operator of
                "" ->
                    model.currentNumberString

                "=" ->
                    model.currentNumberString

                _ ->
                    String.fromFloat model.firstNumber ++ " " ++ model.operator ++ " " ++ model.currentNumberString

        Err errorMessage ->
            errorMessage



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    onKeyDown (Decode.map KeyPressed (Decode.field "key" Decode.string))
