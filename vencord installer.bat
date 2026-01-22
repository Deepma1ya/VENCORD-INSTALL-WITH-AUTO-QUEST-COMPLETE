@echo off
title Vencord Auto Installer (FINAL - NO CRASH)
setlocal enabledelayedexpansion

echo ================================
echo   SCRIPT BY DEEPMALYA
echo ================================
echo.

:: 1. Kill Discord
echo [1/6] Closing Discord...
taskkill /IM discord.exe /F >nul 2>&1
taskkill /IM discordcanary.exe /F >nul 2>&1
taskkill /IM discordptb.exe /F >nul 2>&1
timeout /t 2 >nul

:: 2. Check Node.js
echo [2/6] Checking Node.js...
where node >nul 2>&1
if errorlevel 1 (
    echo Node.js not found. Installing...
    winget install OpenJS.NodeJS -e --silent
) else (
    echo Node.js already installed.
)

:: 3. Check Git
echo [3/6] Checking Git...
where git >nul 2>&1
if errorlevel 1 (
    echo Git not found. Installing...
    winget install Git.Git -e --silent
) else (
    echo Git already installed.
)

timeout /t 3 >nul

:: 4. npm (NO SELF UPDATE)
echo [4/6] Running npm commands...
call npm fund

:: 5. Go to Documents
echo [5/6] Moving to Documents...
cd /d "%USERPROFILE%\Documents"

:: 6. Install Vencord
echo [6/6] Installing Vencord...
if not exist Vencord (
    git clone https://github.com/Vendicated/Vencord
)
cd Vencord

:: Install pnpm if missing
where pnpm >nul 2>&1
if errorlevel 1 (
    call npm i -g pnpm
)

:: Install dependencies
call pnpm i

:: Plugin install
mkdir src\userplugins 2>nul
cd src\userplugins
if not exist completeDiscordQuest (
    git clone https://github.com/nicola02nb/completeDiscordQuest.git
)

cd ..
cd ..
call pnpm build
call pnpm inject

echo.
echo ================================
echo   INSTALLATION COMPLETE
echo ================================
echo Restart Discord manually.
pause
