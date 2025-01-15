# Integer Calculator in Elm

## Description

This project is an **integer calculator** built using **Elm**. It allows users to perform basic arithmetic operations such as addition, subtraction, multiplication, and division. The calculator supports input via buttons and keyboard (numbers and Enter key). Overflow checks are also included to ensure calculations stay within valid integer ranges.

This project was developed as part of the **Applied Programming Paradigms** course during the **1st semester of the Master's degree program** at **FH Salzburg**.

## Features
- Perform basic arithmetic operations: addition, subtraction, multiplication, and division
- Input numbers using on-screen buttons or keyboard (digits `0-9` and the `Enter` key)
- Overflow checks to prevent calculations that exceed valid integer ranges
- Clear functionality to reset the calculator

## Build and Run Instructions

### Requirements
- **Elm**: Make sure you have Elm installed. You can check the official Elm installation guide: https://elm-lang.org/docs/install
- **Shell/Terminal**: For running the build command.

### Build Command
To build the project, run the following command in your terminal:

```bash
./build.sh
```

This will generate the necessary output files to run the Elm project.

### Running the Application
Once the project is built, you can run it by opening the generated HTML file in your browser. To serve the project using a local server, you can use the `elm reactor` command:

```bash
elm reactor
```

After running the above command, open your browser and navigate to the provided URL (typically `http://localhost:8000`) to interact with the calculator.

## How to Use
- Use the on-screen number buttons (`0-9`) to enter numbers.
- Use the arithmetic operation buttons (`+`, `-`, `*`, `/`) to perform operations.
- Press the **Enter** key or the **equals (`=`)** button to calculate the result.
- Press the **Clear (`c`)** button to reset the calculator.

