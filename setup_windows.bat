@echo off
setlocal enabledelayedexpansion

REM Fish Speech Windows Setup Script
REM This script installs dependencies using uv and downloads required models

echo ========================================
echo Fish Speech Windows Setup
echo ========================================
echo.

REM Check if uv is installed
where uv >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo uv is not installed. Installing uv...
    echo This will open a new window. Follow the prompts, then close it and run this script again.
    pause
    powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
    echo.
    echo uv installation complete. Please restart your command prompt and run this script again.
    pause
    exit /b 0
)

echo uv found:
uv --version
echo.

REM Create virtual environment
echo ========================================
echo Creating virtual environment...
echo ========================================
if not exist ".venv" (
    uv venv .venv
    echo Virtual environment created.
) else (
    echo Virtual environment already exists.
)
echo.

REM Activate virtual environment
echo Activating virtual environment...
call .venv\Scripts\activate.bat

REM Install dependencies using uv
echo ========================================
echo Installing dependencies...
echo ========================================
echo This may take a few minutes...
uv pip install -e .
if %ERRORLEVEL% neq 0 (
    echo.
    echo WARNING: Installation had issues. Trying with standard pip...
    python -m pip install -e .
)
echo.

REM Check for CUDA and install appropriate PyTorch
echo ========================================
echo Checking PyTorch installation...
echo ========================================
python -c "import torch; print('PyTorch version:', torch.__version__); print('CUDA available:', torch.cuda.is_available())" 2>nul
if %ERRORLEVEL% neq 0 (
    echo PyTorch not found or incomplete. PyTorch should have been installed with the package.
    echo If you have CUDA issues, visit: https://pytorch.org/get-started/locally/
)
echo.

REM Download models
echo ========================================
echo Downloading Fish Speech S2-Pro models...
echo ========================================
echo This will download approximately 8GB of data.
echo.

REM Check if models already exist
if exist "checkpoints\s2-pro" (
    if exist "checkpoints\s2-pro\codec.pth" (
        echo Models already exist in checkpoints\s2-pro
        echo Skipping download.
        goto :skip_download
    )
)

REM Install huggingface-cli for model download
echo Installing huggingface-cli...
uv pip install -U huggingface_hub
if %ERRORLEVEL% neq 0 (
    echo Failed to install huggingface_hub. Trying alternative method...
    python -m pip install -U huggingface_hub
)
echo.

echo Downloading model weights from HuggingFace...
echo This may take a while depending on your internet connection...
echo Repository: fishaudio/s2-pro
echo Destination: checkpoints\s2-pro
echo.

REM Use hf CLI to download models (renamed from huggingface-cli in hub >= 1.0)
.venv\Scripts\hf.exe download fishaudio/s2-pro --local-dir checkpoints/s2-pro
if %ERRORLEVEL% neq 0 (
    echo.
    echo ========================================
    echo Download may have failed or was interrupted.
    echo ========================================
    echo.
    echo You can try running this command manually:
    echo   .venv\Scripts\hf.exe download fishaudio/s2-pro --local-dir checkpoints/s2-pro
    echo.
    echo Or download manually from: https://huggingface.co/fishaudio/s2-pro
) else (
    echo.
    echo ========================================
    echo Models downloaded successfully!
    echo ========================================
)

:skip_download
echo.

REM Create run scripts
echo ========================================
echo Creating startup scripts...
echo ========================================

REM Server startup script
(
echo @echo off
echo setlocal enabledelayedexpansion
echo.
echo REM Check if virtual environment exists
echo if not exist ".venv" ^(
echo     echo Virtual environment not found!
echo     echo Please run setup_windows.bat first.
echo     pause
echo     exit /b 1
echo ^)
echo.
echo REM Check if models exist
echo if not exist "checkpoints\s2-pro" ^(
echo     echo Models not found in checkpoints\s2-pro
echo     echo Please run setup_windows.bat to download models.
echo     pause
echo     exit /b 1
echo ^)
echo.
echo echo ========================================
echo echo Fish Speech API Server
echo echo ========================================
echo echo.
echo echo Starting API server on: http://localhost:8080
echo echo Web UI will be available at: http://localhost:8080/ui
echo echo.
echo echo Press Ctrl+C to stop the server.
echo echo.
echo call .venv\Scripts\activate.bat
echo python tools/api_server.py --listen 0.0.0.0:8080 --compile
) > start_api_server.bat
echo Created: start_api_server.bat
echo.

REM Simple HTTP server for HTML frontend
(
echo @echo off
echo echo.
echo echo ========================================
echo echo Simple Frontend Server
echo echo ========================================
echo echo.
echo echo This serves the standalone HTML frontend.
echo echo Make sure the API server is running first!
echo echo.
echo echo Frontend: http://localhost:8000
echo echo API Server: http://localhost:8080
echo echo.
echo python -m http.server 8000
) > start_frontend.bat
echo Created: start_frontend.bat
echo.

REM Check if Node.js is available for building the full frontend
where node >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Node.js found. Building full frontend...
    if not exist "awesome_webui\node_modules" (
        echo Installing frontend dependencies...
        cd awesome_webui
        call npm install
        cd ..
    )
    echo Building frontend...
    cd awesome_webui
    call npm run build
    cd ..
    echo Frontend built successfully.
) else (
    echo Node.js not found. The built-in WebUI at /ui will use the pre-built or fallback interface.
    echo Install Node.js from https://nodejs.org/ to build the full React frontend.
)
echo.

REM Create a simple README for the scripts
(
echo Fish Speech Windows Startup Scripts
echo ======================================
echo.
echo 1. start_api_server.bat
echo    Starts the Fish Speech API server.
echo    - Backend API: http://localhost:8080
echo    - Built-in WebUI: http://localhost:8080/ui
echo    - API Docs: http://localhost:8080/docs
echo.
echo 2. start_frontend.bat
echo    Starts a simple HTTP server for the standalone HTML frontend.
echo    - Frontend: http://localhost:8000
echo    - Requires API server to be running on port 8080.
echo.
echo You can also open web_frontend.html directly in your browser.
echo.
echo Note: Make sure to run start_api_server.bat first!
) > STARTUP_GUIDE.txt
echo Created: STARTUP_GUIDE.txt
echo.

echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo To run Fish Speech:
echo   1. Run: start_api_server.bat
echo      This starts the backend API server on http://localhost:8080
echo   2. Open your browser to: http://localhost:8080/ui
echo      Or open web_frontend.html directly
echo.
echo For API documentation, visit: http://localhost:8080/docs
echo.
echo The standalone HTML frontend (web_frontend.html) can be opened
echo directly in your browser once the API server is running.
echo.

pause
