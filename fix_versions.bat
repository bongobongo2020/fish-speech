@echo off
echo Fixing dependency version conflicts...
echo.

call .venv\Scripts\activate.bat

echo Downgrading huggingface-hub to compatible version...
uv pip install "huggingface-hub>=0.34.0,<1.0"

echo.
echo Done! Try running start_api_server.bat again.
pause
