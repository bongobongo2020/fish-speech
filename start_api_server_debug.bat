@echo off
setlocal enabledelayedexpansion

REM Fish Speech API Server Startup Script - Windows (Debug Mode)

echo ========================================
echo Fish Speech API Server (Debug Mode)
echo ========================================
echo.

REM Check if virtual environment exists
if not exist ".venv" (
    echo Virtual environment not found!
    echo Please run setup_windows.bat first.
    pause
    exit /b 1
)

REM Check if models exist
if not exist "checkpoints\s2-pro\codec.pth" (
    echo Models not found in checkpoints\s2-pro
    echo Please run setup_windows.bat to download models.
    pause
    exit /b 1
)

echo Starting API server on: http://localhost:8080
echo Web UI will be available at: http://localhost:8080/ui
echo API Documentation: http://localhost:8080/docs
echo.
echo Press Ctrl+C to stop the server.
echo.

call .venv\Scripts\activate.bat

REM Run with error capture
python tools/api_server.py --listen 0.0.0.0:8080 --compile
if %ERRORLEVEL% neq 0 (
    echo.
    echo ========================================
    echo ERROR: Server exited with code %ERRORLEVEL%
    echo ========================================
    echo.
    pause
)
