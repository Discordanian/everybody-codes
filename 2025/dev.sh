#!bash
git pull
export BIN="/Applications/Godot v4.6.app/Contents/MacOS/Godot"
echo $BIN godot/project.godot
"$BIN" --verbose godot/project.godot
git add godot && git commit -a -m "Saving your bacon" && git push
