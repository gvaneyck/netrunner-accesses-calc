REM Include necessary classes for 4.6 stable
sed -i "s/.*Mutex.*//" netrunner-access-calc.gdbuild
sed -i "s/.*Geometry3D.*//" netrunner-access-calc.gdbuild

REM Build windows
cd ..\..\godot-src
scons target=template_release platform=windows arch=x86_64 optimize=size_extra lto=full debug_symbols=no build_profile=..\godot\netrunner-access-calc\netrunner-access-calc.gdbuild
cd ..\godot\netrunner-access-calc
..\Godot_v4.6-stable_win64.exe --path . --export-release "Tinywindows" netrunner-access-calc.exe

REM Build web
cd ..\..\godot-src
scons target=template_release platform=web threads=no optimize=size_extra lto=full debug_symbols=no build_profile=..\godot\netrunner-access-calc\netrunner-access-calc.gdbuild
cd ..\godot\netrunner-access-calc
..\Godot_v4.6-stable_win64.exe --path . --export-release "Tinyweb" index.html

pause
