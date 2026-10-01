@echo off
title Pull from GitHub - Horizont
cd /d D:\Gemini
echo ===================================================
echo   Pulling latest changes from GitHub...
echo ===================================================
echo.
git pull origin main
echo.
echo ===================================================
echo   Updated successfully!
echo   If Rojo is connected, Studio is synced.
echo ===================================================
pause
