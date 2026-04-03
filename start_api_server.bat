@echo off
setlocal enabledelayedexpansion

REM Check if virtual environment exists
if not exist ".venv" (
    echo Virtual environment not found
    echo Please run setup_windows.bat first.
    pause
    exit /b 1
)

REM Check if models exist
if not exist "checkpoints\s2-pro" (
    echo Models not found in checkpoints\s2-pro
    echo Please run setup_windows.bat to download models.
    pause
    exit /b 1
)

echo ========================================
echo Fish Speech API Server
echo ========================================
echo.
echo Starting API server on: http://localhost:8080
echo Web UI will be available at: http://localhost:8080/ui
echo.
echo Press Ctrl+C to stop the server.
echo.
call .venv\Scripts\activate.bat
python tools/api_server.py --listen 0.0.0.0:8080 --compile
