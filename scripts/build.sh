#!/usr/bin/env bash

set -ex

elm-format src --yes
elm-css src/Stylesheets.elm
elm-make --output=index.js src/Main.elm --yes
