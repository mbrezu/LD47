#!/bin/sh

GODOT=~/Development/godot/Godot_v3.2.3-stable_win64.exe

rm -f builds/*

$GODOT --export HTML5 ../builds/index.html godot/project.godot

cat builds/index.html | sed -e "s/<canvas id='canvas'>/<canvas id='canvas' tabindex='1'>/" > builds/index2.html

cat builds/index2.html | sed -e "s/var canvas = document.getElementById('canvas');/var canvas = document.getElementById('canvas');canvas.focus();/" > builds/index.html

rm builds/index2.html

cd builds

zip -9 ../build.zip *

cd ..