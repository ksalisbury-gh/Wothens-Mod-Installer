:: Wothen's Mod v1.0 (Beta) Installer
:: Author: ksalisbury-gh (Keegan S.)
::
:: Save yourself all that typing and/or downloading and install Wothen's Mod right from this file.

@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
echo:
if '%errorlevel%' NEQ '0' (
	echo ERROR: This installer requires admin to work^!^!^!
	timeout /T "4">nul
	echo Restarting as admin...
	timeout /T "4">nul
	goto UACPrompt
) else ( echo Admin rights detected. && goto proceed )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\admin.vbs"
set params = %*:"=""
echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\admin.vbs"
"%temp%\admin.vbs"
del "%temp%\admin.vbs"
:proceed
pushd "%~dp0"
pushd "%~dp0"
echo "%PATH%" | findstr /C:"git" 1>nul
if errorlevel 1 ( set GIT=N ) else ( set GIT=Y )
echo Welcome to the Wothen's Mod installer!
echo:
echo This is a WIP modification of Wrapper: Offline, with many more possibilities
echo to come!
echo:
echo This installer will install Git and Node.js if you do not already have them.
echo:
echo To proceed press any key to continue.
pause>nul
cls
if "%GIT%"=="N" (
    echo Git was not detected.
    echo:
    timeout /T "4">nul
    echo Downloading and silent-installing Git...
    echo:
    timeout /T "4">nul
	if "%PROCESSOR_ARCHITECTURE%"=="x86" ( set ARC=32 ) else ( set ARC=64 )
    pushd "%temp%"
	call curl -O "https://github.com/git-for-windows/git/releases/download/v2.44.0.windows.1/Git-2.44.0-%ARC%-bit.exe">nul
	pushd "%~dp0"
	call "%temp%\Git-2.44.0-%ARC%-bit.exe" /SILENT
    timeout /T "4">nul
    echo "%PATH%" | findstr /C:"git" 1>nul
    if errorlevel 0 (
        echo Git successfully installed!
        goto GitClone
    ) else ( echo FAIL. Try installing it from the website, git-scm.com. )
) else ( echo Git detected. && set GIT=Y && goto GitClone )
:GitClone
cls
echo Where would you like to install Wothen's Mod?
echo:
echo ^(1^) Current directory
echo ^(%CD%^)
echo:
echo ^(2^) Specify a different directory
set /p DIRECTORYCHOICE=Choice: 
if "%DIRECTORYCHOICE%"=="1" (
    echo You have chosen to install to the current directory.
    set DIRECTORY=%CD%
    timeout /T "4">nul
    call git clone https://github.com/ksalisbury-gh/Wothens-Mod
    timeout /T "4">nul
    echo Repository cloning completed^!^!^!
    timeout /T "4">nul
)
if "%DIRECTORYCHOICE%"=="2" (
    :directorychoice
    cls
    echo Please specify which directory you would like to install to.
    echo:
    set /p DIRECTORY=Directory: 
    echo You have chosen to install to the following directory:
    echo %DIRECTORY%
    echo:
    :directorycorrection
    echo If this looks right, enter any English form of Yes to continue.
    echo Otherwise, enter any English form of No to try again.
    set /p DC=Response: 
    if "%DC:~0,1%"=="Y" (
        echo Directory has been chosen.
        timeout /T "4">nul
        pushd "%DIRECTORY%"
        pushd "%DIRECTORY%"
        call git clone https://github.com/ksalisbury-gh/Wothens-Mod
        timeout /T "4">nul
        echo Repository cloning completed^!^!^!
        timeout /T "4">nul
        goto npminstall
    )
    if "%DC:~0,1%"=="y" (
        echo Directory has been chosen.
        timeout /T "4">nul
        pushd "%DIRECTORY%"
        pushd "%DIRECTORY%"
        call git clone https://github.com/ksalisbury-gh/Wothens-Mod
        timeout /T "4">nul
        echo Repository cloning completed^!^!^!
        timeout /T "4">nul
        goto npminstall
    )
    if "%DC:~0,1%"=="N" ( goto directorychoice )
    if "%DC:~0,1%"=="n" ( goto directorychoice )
)
:npminstall
cls
pushd "%~dp0"
pushd "%~dp0"
echo "%PATH%" | findstr /C:"npm" 1>nul
if errorlevel 1 ( set NPM=N ) else ( set NPM=Y )
if "%NPM%"=="N" (
    echo ERROR: NPM/Node.js not found.
    echo:
    timeout /T "4">nul
	echo Downloading and silent-installing Node.js...
	timeout /T "4">nul
	if "%PROCESSOR_ARCHITECTURE%"=="x86" ( set ARC=86 ) else ( set ARC=64 )
	pushd "%temp%"
	call curl -O "https://nodejs.org/dist/v20.11.1/node-v20.11.1-x%ARC%.msi">nul
	pushd "%~dp0"
	call msiexec /i "%temp%\node-v20.11.1-x%ARC%.msi" /qn
    timeout /T "4">nul
	echo "%PATH%" | findstr /C:"npm" 1>nul
	if errorlevel 1 (
		echo ERROR: NPM/Node.js is STILL not found.
		echo:
		echo Looks like you might have to install it manually,
		echo off of the Node.js website...
		echo:
		pause & exit /B
	) else ( echo Looks like the Node.js silent install completed without failure! )
	if exist "%temp%\node-v20.11.1-x%ARC%.msi" ( del "%temp%\node-v20.11.1-x%ARC%.msi" )
    set NPM=Y
) else (
    echo NPM already installed. Proceeding to installing packages if not done so already...
    timeout /T "4">nul
    goto npmpkginst
)
:npmpkginst
if not exist "%DIRECTORY%\Wothens-Mod\node_modules\" (
    pushd "%DIRECTORY%\Wothens-Mod"
    call npm install
    timeout /T "4">nul
    if exist ".\node_modules\" (
        echo Installation completed^!
    ) else ( echo Didn't work. You might need to do it manually by opening a terminal in the install directory and doing "npm install". && pause & exit /B )
) else ( NPM packages already installed. && timeout /T "4">nul && goto final )
:final
cls
echo Wothen's Mod successfully installed^!
echo:
echo Press any key to launch the directory you installed it to AND to close the installer.
pause>nul
exit /B