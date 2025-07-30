@echo off
setlocal enabledelayedexpansion

:: Define folder structure
set BASE_DIR=%~dp0portable
set GIT_DIR=%BASE_DIR%\git
set PYTHON_DIR=%BASE_DIR%\python
set REPO_DIR=%~dp0repo
set PYTHON_VERSION=311

:: Ensure base directories exist
if not exist "%BASE_DIR%" mkdir "%BASE_DIR%"
if not exist "%REPO_DIR%" mkdir "%REPO_DIR%"

:: Install Portable Git
echo Checking for Portable Git...
if not exist "%GIT_DIR%" (
    echo Downloading Portable Git...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference = 'SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object Net.WebClient).DownloadFile('https://github.com/git-for-windows/git/releases/download/v2.42.0.windows.2/PortableGit-2.42.0.2-64-bit.7z.exe', '%BASE_DIR%\git.exe')" || (
        echo Failed to download Git. Exiting.
        exit /b 1
    )
    echo Extracting Portable Git...
    start /wait "" "%BASE_DIR%\git.exe" -y -o"%GIT_DIR%" || (
        echo Failed to extract Portable Git. Exiting.
        exit /b 1
    )
    del "%BASE_DIR%\git.exe"
) else (
    echo Portable Git already exists.
)

:: Set Git paths and configuration
echo Setting up Git environment...
set PATH=%GIT_DIR%\bin;%GIT_DIR%\cmd;%GIT_DIR%\mingw64\bin;%GIT_DIR%\usr\bin;%PATH%
set TERM=msys
set HOME=%USERPROFILE%
set GIT_EXEC_PATH=%GIT_DIR%\mingw64\libexec\git-core
set GIT_TEMPLATE_DIR=%GIT_DIR%\mingw64\share\git-core\templates

:: Initialize Git (needed for first use)
if not exist "%GIT_DIR%\etc\gitconfig" (
    echo Initializing Git configuration...
    "%GIT_DIR%\cmd\git.exe" config --system --add safe.directory "*"
)

:: Verify Git is working
echo Testing Git installation...
"%GIT_DIR%\cmd\git.exe" --version || (
    echo Error: Git installation appears to be corrupted. Please check the logs.
    exit /b 1
)

:: Install Portable Python
echo Checking for Portable Python...
if not exist "%PYTHON_DIR%" (
    echo Downloading Python installer...
    powershell -Command "Invoke-WebRequest -Uri https://www.python.org/ftp/python/3.11.5/python-3.11.5-embed-amd64.zip -OutFile %BASE_DIR%\python.zip"
    
    echo Extracting Python...
    powershell -Command "Expand-Archive -Path %BASE_DIR%\python.zip -DestinationPath %PYTHON_DIR%" || (
        echo Failed to extract Python. Exiting.
        exit /b 1
    )
    del "%BASE_DIR%\python.zip"
    
    echo Configuring Python environment...
    
    :: Create directories
    mkdir "%PYTHON_DIR%\Lib" 2>nul
    mkdir "%PYTHON_DIR%\Lib\site-packages" 2>nul
    mkdir "%PYTHON_DIR%\Scripts" 2>nul
    
    :: Configure python311._pth
    echo python311.zip> "%PYTHON_DIR%\python311._pth"
    echo .>> "%PYTHON_DIR%\python311._pth"
    echo Lib>> "%PYTHON_DIR%\python311._pth"
    echo Lib\site-packages>> "%PYTHON_DIR%\python311._pth"
    echo .>> "%PYTHON_DIR%\python311._pth"
    echo import site>> "%PYTHON_DIR%\python311._pth"
    
    :: Install pip using ensurepip
    echo Installing pip...
    "%PYTHON_DIR%\python.exe" -m ensurepip --default-pip || (
        echo Failed to install pip. Downloading get-pip.py...
        powershell -Command "Invoke-WebRequest -Uri https://bootstrap.pypa.io/get-pip.py -OutFile %BASE_DIR%\get-pip.py"
        "%PYTHON_DIR%\python.exe" "%BASE_DIR%\get-pip.py" --no-warn-script-location || (
            echo Failed to install pip. Exiting.
            exit /b 1
        )
        del "%BASE_DIR%\get-pip.py"
    )
    
    :: Update pip to latest version
    echo Updating pip...
    "%PYTHON_DIR%\python.exe" -m pip install --upgrade pip --no-warn-script-location || (
        echo Failed to update pip. Exiting.
        exit /b 1
    )
) else (
    echo Portable Python already exists.
)
set PATH=%PYTHON_DIR%;%PATH%

:: Add Python Scripts directory to PATH
echo Adding Python Scripts directory to PATH...
set PATH=%PYTHON_DIR%\Scripts;%PATH%

:: Check if Git is available
"%GIT_DIR%\bin\git.exe" --version >nul 2>&1 || (
    echo Git is not available. Please check the installation.
    exit /b 1
)

:: Check if Python is available
%PYTHON_DIR%\python.exe --version >nul 2>&1 || (
    echo Python is not available. Please check the installation.
    exit /b 1
)

:: Prompt for repository URL
set /p REPO_URL="Enter the GitHub repository URL to clone (or press Enter to skip): "
if not "%REPO_URL%"=="" (
    echo Cloning repository from %REPO_URL%...
    "%GIT_DIR%\bin\git.exe" clone "%REPO_URL%" "%REPO_DIR%"
) else (
    echo Repository cloning skipped.
)

:: Check for requirements.txt and install dependencies
if exist "%REPO_DIR%\requirements.txt" (
    echo Installing Python dependencies...
    %PYTHON_DIR%\python.exe -m pip install -r "%REPO_DIR%\requirements.txt"
) else (
    echo No requirements.txt found.
)

echo Development environment setup complete.
pause
