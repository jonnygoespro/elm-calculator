# Elm Calculator

## Description

This project is a **calculator** built with **Elm** that supports basic arithmetic operations (addition, subtraction, multiplication, division) and the modulo operation. It also handles numbers with up to **10 decimal places** and prevents overflow errors.

## Build and Run Instructions

### Requirements
- **Elm**: [Installation Guide](https://elm-lang.org/docs/install)
- **Node.js** and **npm** (only for minification): Install `uglify-js` globally if you want to minify the build:
  ```bash
  npm install -g uglify-js
  ```
- **Shell/Terminal**: To run the build command.

### Build Command

To build the project, run:

```bash
./build.sh
```

This will compile the Elm code to `./target/elm.js`. To build a minified version, use the `--minify` flag:

```bash
./build.sh --minify
```

This will generate `elm.min.js` and adjust the HTML accordingly.

### Running the Application

To run the application, serve it using `elm reactor`:

```bash
elm reactor
```

Open your browser and navigate to `http://localhost:8000/target/index.html` to interact with the calculator.
