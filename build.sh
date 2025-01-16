#!/bin/sh

set -e

# Variables
src="./src/Main.elm"
html_src="./src/index.html"
target="./target"
js="$target/elm.js"
min="$target/elm.min.js"
html_target="$target/index.html"

# Ensure target directory exists
mkdir -p $target

# Determine build mode
if [ "$1" = "--minify" ]; then
    # Minify build
    echo "Building with minification..."
    elm make --optimize --output=$js $src

    uglifyjs $js --compress 'pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe' | \
    uglifyjs --mangle --output $min

    # Update and copy index.html for minified build
    sed 's|<!-- Link to Main.elm -->|<script src="./elm.min.js"></script>|' $html_src > $html_target

    # Display sizes
    echo "Compiled size: $(wc -c < $js) bytes ($js)"
    echo "Minified size: $(wc -c < $min) bytes ($min)"
    echo "Gzipped size:  $(gzip -c $min | wc -c) bytes"
else
    # Normal build
    echo "Building without minification..."
    elm make --output=$js $src

    # Update and copy index.html for normal build
    sed 's|<!-- Link to Main.elm -->|<script src="./elm.js"></script>|' $html_src > $html_target

    # Display size
    echo "Compiled size: $(wc -c < $js) bytes ($js)"
fi

echo "Build complete! Files are in $target/"
