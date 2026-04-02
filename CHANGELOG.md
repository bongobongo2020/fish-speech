# Changelog

## Windows Setup and Frontend Implementation

### Files Created

1. **setup_windows.bat** - Windows setup script that:
   - Checks for and installs `uv` if not present
   - Creates a virtual environment in `.venv`
   - Installs all dependencies using `uv pip install -e .`
   - Downloads the Fish Speech S2-Pro models from HuggingFace
   - Creates startup scripts for the API server and frontend
   - Optionally builds the React frontend if Node.js is available

2. **start_api_server.bat** - Script to start the Fish Speech API server
   - Checks for virtual environment and models
   - Starts the API server on http://localhost:8080
   - Built-in WebUI available at http://localhost:8080/ui

3. **start_frontend.bat** - Script to start a simple HTTP server for the standalone HTML frontend
   - Serves web_frontend.html on http://localhost:8000
   - Requires the API server to be running on port 8080

4. **start_all.bat** - Main startup script
   - Combines functionality for a simple startup experience
   - Starts the API server with all available interfaces

5. **web_frontend.html** - Standalone HTML/JS frontend
   - Single-file interface that connects to the backend API
   - Features:
     - Text input area with default example text
     - Reference audio upload for voice cloning
     - Audio output player with streaming support
     - Generation settings (format, latency, chunk length, temperature, etc.)
     - Connection status indicator
     - Metrics display (size, time to first token)
     - Download generated audio
   - Works directly in the browser when API server is running

6. **STARTUP_GUIDE.txt** - Quick reference guide for the startup scripts

### Usage Instructions

1. First-time setup:
   ```
   setup_windows.bat
   ```
   This will install uv, create the virtual environment, install dependencies, and download models.

2. Start the Fish Speech API server:
   ```
   start_api_server.bat
   ```
   or
   ```
   start_all.bat
   ```

3. Access the web interface:
   - Built-in WebUI: http://localhost:8080/ui
   - Standalone HTML: Open web_frontend.html in your browser
   - API Documentation: http://localhost:8080/docs

### Dependencies

The setup script uses:
- `uv` - Fast Python package installer (auto-installed if missing)
- `huggingface-cli` - For downloading model weights (auto-installed)
- `python` - Python 3.10+ required
- `node.js` - Optional, for building the full React frontend

### Model Download

The script downloads the Fish Speech S2-Pro model from HuggingFace:
- Repository: `fishaudio/s2-pro`
- Destination: `checkpoints/s2-pro`
- Size: ~8GB

The download can be resumed if interrupted. Models are cached and won't be re-downloaded if already present.
