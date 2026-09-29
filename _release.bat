REM Include necessary classes for 4.6 stable
sed -i "s/.*Mutex.*//" netrunner-access-calc.gdbuild
sed -i "s/.*Geometry3D.*//" netrunner-access-calc.gdbuild

REM Build engine
cd ..\..\godot-src
scons target=template_release platform=windows arch=x86_64 optimize=size_extra lto=full debug_symbols=no build_profile=..\godot\netrunner-access-calc\netrunner-access-calc.gdbuild
scons target=template_release platform=web threads=no optimize=size_extra lto=full debug_symbols=no build_profile=..\godot\netrunner-access-calc\netrunner-access-calc.gdbuild

REM Strip symbols (in case scons switch doesn't do it)
strip -s bin\godot.windows.template_release.x86_64.console.exe
strip -s bin\godot.windows.template_release.x86_64.exe

REM Build exe
cd ..\godot\netrunner-access-calc
..\Godot_v4.6-stable_win64.exe --path . --export-release "Tinywindows" netrunner-access-calc.exe
..\Godot_v4.6-stable_win64.exe --path . --export-release "Tinyweb" index.html

pause
