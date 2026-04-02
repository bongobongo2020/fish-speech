@echo off
setlocal enabledelayedexpansion

REM Fish Speech Startup Script - Windows
REM This script starts both the backend API and serves the frontend

echo ========================================
echo Fish Speech Startup
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

echo Starting Fish Speech...
echo.
echo ========================================
echo Available Interfaces:
echo ========================================
echo.
echo 1. Built-in WebUI: http://localhost:8080/ui
echo 2. Standalone HTML: Open web_frontend.html in your browser
echo 3. API Docs: http://localhost:8080/docs
echo.
echo Backend API: http://localhost:8080
echo.
echo Press Ctrl+C to stop the server.
echo.

REM Activate virtual environment and start API server
call .venv\Scripts\activate.bat
python tools/api_server.py --listen 0.0.0.0:8080 --compile
