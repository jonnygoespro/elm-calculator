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
    }


init : Model
init =
    { output = Ok "0"
    , operator = ""
    , firstNumber = 0
    , secondNumber = 0
    }



-- UPDATE


type Msg
    = NumberButtonClicked Float
    | ClearButtonClicked
    | OperatorButtonClicked String
    | EqualSignButtonClicked
    | DeleteButtonPressed
    | CommaButtonPressed
    | KeyPressed String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NumberButtonClicked newNumber ->
            case model.output of
                Ok currentOutput ->
                    case model.operator of
                        "=" ->
                            let
                                newFirstNumber =
                                    appendDigitToNumber model.firstNumber (getLastChar currentOutput) (round newNumber)
                            in
                            case newFirstNumber of
                                Just number ->
                                    ( { model | firstNumber = number, output = Ok (String.fromFloat number) }, Cmd.none )

                                Nothing ->
                                    ( { model | firstNumber = 0, secondNumber = 0, operator = "", output = Err "Overflow occured" }, Cmd.none )

                        "" ->
                            let
                                newFirstNumber =
                                    appendDigitToNumber model.firstNumber (getLastChar currentOutput) (round newNumber)
                            in
                            case newFirstNumber of
                                Just number ->
                                    ( { model | firstNumber = number, output = Ok (String.fromFloat number) }, Cmd.none )

                                Nothing ->
                                    ( { model | firstNumber = 0, secondNumber = 0, operator = "", output = Err "Overflow occured" }, Cmd.none )

                        _ ->
                            let
                                newSecondNumber =
                                    appendDigitToNumber model.secondNumber (getLastChar currentOutput) (round newNumber)
                            in
                            case newSecondNumber of
                                Just number ->
                                    ( { model | secondNumber = number, output = Ok (displayOutput model.output model.firstNumber model.operator number) }, Cmd.none )

                                Nothing ->
                                    ( { model | firstNumber = 0, secondNumber = 0, operator = "", output = Err "Overflow occured" }, Cmd.none )

                Err _ ->
                    ( { model | firstNumber = newNumber, secondNumber = 0, operator = "", output = Ok (String.fromFloat newNumber) }, Cmd.none )

        ClearButtonClicked ->
            ( { model | output = Ok "0", firstNumber = 0, secondNumber = 0, operator = "" }, Cmd.none )

        OperatorButtonClicked operator ->
            ( handleOperator model operator, Cmd.none )

        DeleteButtonPressed ->
            case model.output of
                Ok _ ->
                    ( model, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        EqualSignButtonClicked ->
            case model.output of
                Ok _ ->
                    let
                        result =
                            calculate model.firstNumber model.operator model.secondNumber
                    in
                    case result of
                        Ok value ->
                            ( { model | output = Ok (String.fromFloat value), firstNumber = value, secondNumber = 0, operator = "=" }, Cmd.none )

                        Err errorMessage ->
                            ( { model | output = Err errorMessage, firstNumber = 0, secondNumber = 0, operator = "" }, Cmd.none )

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
                    update (OperatorButtonClicked "+") model

                "-" ->
                    update (OperatorButtonClicked "-") model

                "*" ->
                    update (OperatorButtonClicked "*") model

                "/" ->
                    update (OperatorButtonClicked "/") model

                "%" ->
                    update (OperatorButtonClicked "%") model

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

        CommaButtonPressed ->
            case model.operator of
                "" ->
                    if isWholeNumber model.firstNumber then
                        ( { model | output = Ok (displayOutput model.output model.firstNumber model.operator model.secondNumber ++ ".") }, Cmd.none )

                    else
                        ( model, Cmd.none )

                "=" ->
                    if isWholeNumber model.firstNumber then
                        ( { model | output = Ok (displayOutput model.output model.firstNumber model.operator model.secondNumber ++ ".") }, Cmd.none )

                    else
                        ( model, Cmd.none )

                _ ->
                    if isWholeNumber model.secondNumber then
                        ( { model | output = Ok (displayOutput model.output model.firstNumber model.operator model.secondNumber ++ ".") }, Cmd.none )

                    else
                        ( model, Cmd.none )


handleOperator : Model -> String -> Model
handleOperator model operator =
    case model.output of
        Ok _ ->
            { model | operator = operator, output = Ok (displayOutput model.output model.firstNumber operator model.secondNumber) }

        Err _ ->
            model


calculate : Float -> String -> Float -> Result String Float
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
                Err "Cannot divide by zero"

            else
                checkOverflow (firstNumber / secondNumber)

        "%" ->
            checkOverflow (toFloat (modBy (round secondNumber) (round firstNumber)))

        _ ->
            Err "Invalid operation"


checkOverflow : Float -> Result String Float
checkOverflow number =
    if number < -2147483648 || number > 2147483647 then
        Err "Overflow occured"

    else
        Ok number


isWholeNumber : Float -> Bool
isWholeNumber number =
    number == toFloat (round number)


getLastChar : String -> Maybe Char
getLastChar str =
    case String.reverse str |> String.uncons of
        Just ( lastChar, _ ) ->
            Just lastChar

        Nothing ->
            Nothing


appendDigitToNumber : Float -> Maybe Char -> Int -> Maybe Float
appendDigitToNumber number comma digit =
    let
        numberAsString =
            String.fromFloat number

        digitAsString =
            String.fromInt digit

        newNumberAsString =
            case comma of
                Just lastDigit ->
                    if lastDigit == '.' then
                        numberAsString ++ String.fromChar lastDigit ++ digitAsString

                    else
                        numberAsString ++ digitAsString

                Nothing ->
                    numberAsString ++ digitAsString
    in
    String.toFloat newNumberAsString



-- VIEW


view : Model -> Html Msg
view model =
    let
        outputText =
            case model.output of
                Ok output ->
                    output

                Err errorMessage ->
                    errorMessage
    in
    div [ id "calculator", Attr.tabindex 0 ]
        [ p [ class "output" ] [ text outputText ]
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


displayOutput : Result String String -> Float -> String -> Float -> String
displayOutput output firstNumber operator secondNumber =
    case output of
        Ok _ ->
            case operator of
                "" ->
                    String.fromFloat firstNumber

                "=" ->
                    String.fromFloat firstNumber

                _ ->
                    String.fromFloat firstNumber ++ " " ++ operator ++ " " ++ String.fromFloat secondNumber

        Err errorMessage ->
            errorMessage



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    onKeyDown (Decode.map KeyPressed (Decode.field "key" Decode.string))
