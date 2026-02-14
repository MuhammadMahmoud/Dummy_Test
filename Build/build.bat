@echo off
echo ============================
echo Building Mini Bank Project
echo ============================

make -f makefile.mk clean
make -f makefile.mk

if %ERRORLEVEL% == 0 (
    echo.
    echo Build Successful!
    echo Executable: mini_bank.exe
) else (
    echo.
    echo Build Failed!
)

