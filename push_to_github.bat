@echo off
title Push to GitHub - Horizont
cd /d D:\Gemini
echo ===================================================
echo   Saving and Pushing to GitHub:
echo   https://github.com/IlyshkaColeman/Horizont.git
echo ===================================================
echo.
git add .
git commit -m "update: sync project files and place"
git push origin main
echo.
echo ===================================================
echo   Successfully pushed to GitHub!
echo ===================================================
pause
