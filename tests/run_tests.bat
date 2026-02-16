@echo off
REM ============================================================================
REM Robot Framework Integration Tests Runner
REM ============================================================================
REM This script runs the integration tests for the Mini Bank System
REM Tests actual C code using dynamic code injection
REM ============================================================================

setlocal enabledelayedexpansion

REM Get directory where this script is located
set SCRIPT_DIR=%~dp0
cd /d "%SCRIPT_DIR%"

echo.
echo ============================================================================
echo Robot Framework Integration Tests
echo ============================================================================
echo.
echo Running tests from: %SCRIPT_DIR%
echo.

REM Run tests with Robot Framework
python -m robot -P . integration_tests.robot

REM Capture exit code
set EXIT_CODE=%ERRORLEVEL%

echo.
echo ============================================================================
if %EXIT_CODE% equ 0 (
    echo TEST RUN COMPLETED SUCCESSFULLY
    echo All tests passed!
) else (
    echo TEST RUN FAILED
    echo Some tests did not pass. Check the output above.
)
echo ============================================================================
echo.

REM Exit with the same code as robot
exit /b %EXIT_CODE%
