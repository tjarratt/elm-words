#!/usr/bin/env bash

set -ex

# jump to the root directory
cd $(dirname $0)/..

# ensure we build the latest version
scripts/build.sh

# cleanup any old assets
rm -rf tmp/*

# populate the directory we deploy from
cp index.html wordgame.css index.js Staticfile favicon.ico tmp

# golden onramp, yo -- you crazy for this one, sct ! it's your boy !
cf push wodens-words
