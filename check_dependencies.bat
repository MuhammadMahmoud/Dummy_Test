@echo off
REM Mini Bank Project - Dependency Checker
REM Checks for gcc, make, and Robot Framework

setlocal enabledelayedexpansion

echo.
echo =========================================================================
echo Mini Bank Project - Dependency Checker
echo =========================================================================
echo.

set "missing="

REM Check GCC
echo Checking GCC Compiler...
gcc --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] GCC compiler is installed
) else (
    echo [MISSING] GCC compiler is NOT installed
    set "missing=!missing! GCC"
    echo.
    echo Installation options for GCC:
    echo   1. MinGW: https://www.mingw-w64.org/
    echo   2. Chocolatey: choco install mingw
    echo   3. MSYS2: https://www.msys2.org/
    echo.
)

REM Check Make
echo Checking Make Tool...
make --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Make tool is installed
) else (
    echo [MISSING] Make tool is NOT installed
    set "missing=!missing! Make"
    echo.
    echo Installation options for Make:
    echo   1. MinGW: https://www.mingw-w64.org/
    echo   2. Chocolatey: choco install make
    echo   3. MSYS2: pacman -S make
    echo   4. GNUWin32: http://gnuwin32.sourceforge.net/packages/make.htm
    echo.
)

REM Check Python
echo Checking Python...
python --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Python is installed
    
    REM Check Robot Framework
    echo Checking Robot Framework...
    python -c "import robot" >nul 2>&1
    if %errorlevel% equ 0 (
        echo [OK] Robot Framework is installed
    ) else (
        echo [MISSING] Robot Framework is NOT installed
        set "missing=!missing! Robot-Framework"
        echo.
        echo Installation options for Robot Framework:
        echo   1. pip install robotframework
        echo   2. conda install -c conda-forge robotframework
        echo.
    )
) else (
    echo [MISSING] Python is NOT installed
    set "missing=!missing! Python"
    echo.
    echo Installation options for Python:
    echo   1. python.org: https://www.python.org/downloads/
    echo   2. Chocolatey: choco install python
    echo.
    echo IMPORTANT: Check "Add Python to PATH" during installation
    echo After installation, run: pip install robotframework
    echo.
)

REM Summary
echo.
echo =========================================================================
echo SUMMARY
echo =========================================================================
echo.

if "!missing!"=="" (
    echo.
    echo [SUCCESS] All dependencies installed successfully!
    echo.
    echo Project is ready. You can now run tests with:
    echo.
    echo   .\run_tests.bat inside the tests directory
    echo.
) else (
    echo.
    echo [ERROR] Missing dependencies:!missing!
    echo.
    echo Please install the missing tools above and run this check again.
    echo.
)

endlocal
