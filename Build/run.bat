@echo off
echo ============================
echo Running Mini Bank Project
echo ============================
echo.

if exist mini_bank.exe (
    echo Launching mini_bank.exe...
    echo.
    mini_bank.exe
    echo.
    echo Program execution completed.
) else (
    echo.
    echo Error: mini_bank.exe not found!
    echo Please build the project first using build.bat
)

echo.
pause
