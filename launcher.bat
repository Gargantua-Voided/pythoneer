@echo off
setlocal enabledelayedexpansion

:: Define folder structure (same as setup script)
set BASE_DIR=%~dp0portable
set GIT_DIR=%BASE_DIR%\git
set PYTHON_DIR=%BASE_DIR%\python
set REPO_DIR=%~dp0repo

:: Set up Git environment
set PATH=%GIT_DIR%\bin;%GIT_DIR%\cmd;%GIT_DIR%\mingw64\bin;%GIT_DIR%\usr\bin;%PATH%
set TERM=msys
set HOME=%USERPROFILE%
set GIT_EXEC_PATH=%GIT_DIR%\mingw64\libexec\git-core
set GIT_TEMPLATE_DIR=%GIT_DIR%\mingw64\share\git-core\templates

:: Set up Python environment
set PATH=%PYTHON_DIR%;%PYTHON_DIR%\Scripts;%PATH%

:: Ensure pip is installed
if not exist "%PYTHON_DIR%\Scripts\pip.exe" (
    echo Installing pip...
    powershell -Command "Invoke-WebRequest -Uri https://bootstrap.pypa.io/get-pip.py -OutFile %PYTHON_DIR%\get-pip.py"
    "%PYTHON_DIR%\python.exe" "%PYTHON_DIR%\get-pip.py" --no-warn-script-location
    del "%PYTHON_DIR%\get-pip.py"
)

:: Change to repository directory
cd "%REPO_DIR%"

:: Set up command aliases that work in both CMD and PowerShell
set PYTHON_CMD=%PYTHON_DIR%\python.exe
set PIP_CMD=%PYTHON_DIR%\python.exe -m pip
set GIT_CMD=%GIT_DIR%\bin\git.exe

:: Create doskey aliases for CMD
doskey python=%PYTHON_CMD% $*
doskey pip=%PIP_CMD% $*
doskey git=%GIT_CMD% $*

:: Launch a new command prompt with the environment
echo Portable development environment ready!
echo.
echo Available commands:
echo   python - runs Python interpreter
echo   pip - runs pip package manager
echo   git - runs Git commands
echo.
echo Examples:
echo   pip install requests
echo   python script.py
echo   git status
echo.
echo Working directory: %REPO_DIR%
echo Type 'exit' to leave the environment
echo.
cmd /k
