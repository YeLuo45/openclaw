@echo off
chcp 65001 >nul
echo ==========================================
echo  Fix Feishu Plugin and Start Gateway
echo ==========================================

:: Step 1: Install dependencies for feishu plugin
echo.
echo [1/3] Installing Feishu plugin dependencies...
cd /d "%USERPROFILE%\.openclaw\extensions\openclaw-feishu"

:: Remove broken node_modules if exists
if exist "node_modules" (
    echo Removing existing node_modules...
    rmdir /S /Q "node_modules" 2>nul
    timeout /t 1 >nul
)

:: Install dependencies
echo Installing @larksuiteoapi/node-sdk and zod...
call npm install @larksuiteoapi/node-sdk zod --save --legacy-peer-deps 2>&1

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to install dependencies
    pause
    exit /b 1
)

:: Step 2: Add bindings to config
echo.
echo [2/3] Adding bindings configuration...
cd /d "%USERPROFILE%\.openclaw"

:: Create temporary Python script to add bindings
>add_bindings.py (
echo import json
echo import sys
echo import os
echo config_path = os.path.expanduser('~/.openclaw/openclaw.json')
echo try:
echo     with open(config_path, 'r', encoding='utf-8') as f:
echo         config = json.load(f)
echo     if 'bindings' not in config:
echo         config['bindings'] = [{'agentId': 'main', 'match': {'channel': 'openclaw-feishu', 'accountId': 'default'}}]
echo         print('Added bindings configuration')
echo     else:
echo         print('Bindings already exists')
echo     if 'routing' in config:
echo         del config['routing']
echo         print('Removed routing key')
echo     with open(config_path, 'w', encoding='utf-8') as f:
echo         json.dump(config, f, indent=2, ensure_ascii=False)
echo     print('Configuration updated successfully')
echo     sys.exit(0)
echo except Exception as e:
echo     print(f'Error: {e}')
echo     sys.exit(1)
)

python add_bindings.py
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to update configuration
    del add_bindings.py 2>nul
    pause
    exit /b 1
)
del add_bindings.py 2>nul

:: Step 3: Restart Gateway
echo.
echo [3/3] Restarting Gateway...
cd /d "G:\WS\ai-tools\opensource\openclaw"
set OPENCLAW_STATE_DIR=%USERPROFILE%\.openclaw
echo Starting Gateway... (Press Ctrl+C to stop)
echo.
node openclaw.mjs gateway

pause
