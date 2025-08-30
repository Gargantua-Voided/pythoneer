@echo off
setlocal enabledelayedexpansion

:: Define folder structure
set BASE_DIR=%~dp0portable
set GIT_DIR=%BASE_DIR%\git
set PYTHON_DIR=%BASE_DIR%\python
set REPO_DIR=%~dp0repo
set FFMPEG_DIR=%BASE_DIR%\ffmpeg

:: Set up Git environment
set PATH=%GIT_DIR%\bin;%GIT_DIR%\cmd;%GIT_DIR%\mingw64\bin;%GIT_DIR%\usr\bin;%PATH%
set TERM=msys
set HOME=%USERPROFILE%
set GIT_EXEC_PATH=%GIT_DIR%\mingw64\libexec\git-core
set GIT_TEMPLATE_DIR=%GIT_DIR%\mingw64\share\git-core\templates

:: Set up Python environment
set PATH=%PYTHON_DIR%;%PYTHON_DIR%\Scripts;%PATH%

:: Download and set up pip if missing
if not exist "%PYTHON_DIR%\Scripts\pip.exe" (
    echo Installing pip...
    powershell -Command "Invoke-WebRequest -Uri https://bootstrap.pypa.io/get-pip.py -OutFile %PYTHON_DIR%\get-pip.py"
    "%PYTHON_DIR%\python.exe" "%PYTHON_DIR%\get-pip.py" --no-warn-script-location
    del "%PYTHON_DIR%\get-pip.py"
)

:: Download FFmpeg portable if not present
if not exist "%FFMPEG_DIR%\bin\ffmpeg.exe" (
    echo Downloading FFmpeg...
    powershell -Command "Invoke-WebRequest -Uri https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip -OutFile %BASE_DIR%\ffmpeg.zip"
    echo Extracting FFmpeg...
    powershell -Command "Expand-Archive -Path %BASE_DIR%\ffmpeg.zip -DestinationPath %BASE_DIR% -Force"
    :: Rename extracted folder to standard name
    for /d %%D in (%BASE_DIR%\ffmpeg-*-essentials_build) do move "%%D" "%FFMPEG_DIR%"
    del "%BASE_DIR%\ffmpeg.zip"
)

:: Add FFmpeg to PATH temporarily
set PATH=%FFMPEG_DIR%\bin;%PATH%

:: Change to repository directory
cd "%REPO_DIR%"

:: Set up command aliases
set PYTHON_CMD=%PYTHON_DIR%\python.exe
set PIP_CMD=%PYTHON_DIR%\python.exe -m pip
set GIT_CMD=%GIT_DIR%\bin\git.exe
set FFMPEG_CMD=%FFMPEG_DIR%\bin\ffmpeg.exe

:: Create doskey aliases for CMD
doskey python=%PYTHON_CMD% $*
doskey pip=%PIP_CMD% $*
doskey git=%GIT_CMD% $*
doskey ffmpeg=%FFMPEG_CMD% $*

:: Launch environment
echo Portable development environment ready!
echo.
echo Available commands:
echo   python - runs Python interpreter
echo   pip - runs pip package manager
echo   git - runs Git commands
echo   ffmpeg - runs FFmpeg
echo.
echo Examples:
echo   pip install requests
echo   python script.py
echo   git status
echo   ffmpeg -version
echo.
echo Working directory: %REPO_DIR%
echo Type 'exit' to leave the environment
echo.
cmd /k
