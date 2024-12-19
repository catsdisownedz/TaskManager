#!/usr/bin/env bash
# utils.sh
# Utility functions for the Zenity GUI components.

# HTML styling for text in Zenity
# Using a monospace font and colored text
# We'll define a helper to wrap text in HTML with given color:
color_text() {
    local color="$1"
    local text="$2"
    echo "<span face='Monospace' foreground='${color}'>${text}</span>"
}

# For titles and headings, we can combine colors:
heading_text() {
    local text="$1"
    # Use orange for headings
    echo "<span face='Monospace' foreground='#FFA500'><b>${text}</b></span>"
}

# For body text (pink):
body_text() {
    local text="$1"
    echo "<span face='Monospace' foreground='#FF00FF'>${text}</span>"
}

# For additional emphasis or different sections (blue):
info_text() {
    local text="$1"
    echo "<span face='Monospace' foreground='#0000FF'>${text}</span>"
}
