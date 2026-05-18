@echo off
setlocal

REM Check if Git is installed
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Git is not installed. Installing Git...
    REM Download and install Git (adjust the URL to the latest Git installer if necessary)
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/git-for-windows/git/releases/download/v2.48.1.windows.1/Git-2.48.1-64-bit.exe' -OutFile 'Git-2.48.1-64-bit.exe'; Start-Process -FilePath '.\Git-2.48.1-64-bit.exe' -Wait"
    if %errorlevel% neq 0 (
        echo Failed to install Git.
        exit /b 1
    )
    echo Git installed successfully.
) else (
    echo Git is already installed.
)

REM Set the path to the directory containing the bundled Python executable
set BUNDLED_PATH=%~dp0Python39

REM Debugging statement to print the bundled path
echo Bundled path: %BUNDLED_PATH%

REM Check if the virtual environment exists, if not, create it
if not exist "venv\Scripts\activate" (
    echo Virtual environment not found. Creating virtual environment...
    "%BUNDLED_PATH%\python.exe" -m venv venv
    if %errorlevel% neq 0 (
        echo Failed to create virtual environment.
        exit /b 1
    )
    echo Virtual environment created successfully.
)

REM Path to the pyvenv.cfg file
set PYVENV_CFG=venv\pyvenv.cfg

REM Update the pyvenv.cfg file to set the home path to the bundled Python executable
if exist "%PYVENV_CFG%" (
    > "%PYVENV_CFG%" (
        echo home = %BUNDLED_PATH%
        echo include-system-site-packages = false
        echo version = 3.9.13
    )
    echo Updated pyvenv.cfg with home path: %BUNDLED_PATH%
) else (
    echo pyvenv.cfg not found.
)

REM Activate the virtual environment
call venv\Scripts\activate

REM Check if the quest package is installed using the virtual environment's pip
venv\Scripts\pip show quest >nul 2>&1
if %errorlevel% neq 0 (
    echo quest package is not installed. Installing quest...
    REM Run pip install -e . using the virtual environment's pip
    venv\Scripts\pip install -e .
) else (
    echo quest package is already installed.
)

REM Add the Scripts directory to the PATH
set PATH=%BUNDLED_PATH%\Scripts;%PATH%
set PATH=%PATH%;%~dp0glpk\glpk-4.65\w64

REM Run the quest module using the virtual environment's Python interpreter
venv\Scripts\python -m quest

endlocal
exit /b 0
