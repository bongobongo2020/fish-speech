@echo off

REM Fish Speech Simple Frontend Server - Windows

echo.
echo ========================================
echo Simple Frontend Server
echo ========================================
echo.
echo This serves the standalone HTML frontend.
echo Make sure the API server is running first!
echo.
echo Frontend: http://localhost:8000
echo API Server: http://localhost:8080
echo.
echo Press Ctrl+C to stop the server.
echo.

python -m http.server 8000
