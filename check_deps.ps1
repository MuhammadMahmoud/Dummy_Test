# Mini Bank Project - Dependency Checker
# Validates gcc, make, and Robot Framework installation

param()

# Colors
$Green = [ConsoleColor]::Green
$Red = [ConsoleColor]::Red
$Yellow = [ConsoleColor]::Yellow
$Cyan = [ConsoleColor]::Cyan

$all_ok = $true
$missing = @()

Write-Host ""
Write-Host "=" * 70 -ForegroundColor $Cyan
Write-Host "Mini Bank Project - Dependency Checker" -ForegroundColor $Cyan
Write-Host "=" * 70 -ForegroundColor $Cyan
Write-Host ""

# Check GCC
Write-Host "Checking GCC Compiler..." -ForegroundColor $Cyan
$gcc_found = $null -ne (Get-Command gcc -ErrorAction SilentlyContinue)

if ($gcc_found) {
    $gcc_ver = gcc --version 2>&1 | Select-Object -First 1
    Write-Host "✓ GCC is installed" -ForegroundColor $Green
    Write-Host "  $gcc_ver" -ForegroundColor $Green
} else {
    Write-Host "✗ GCC is NOT installed" -ForegroundColor $Red
    $all_ok = $false
    $missing += "GCC"
    
    Write-Host ""
    Write-Host "Installation options for GCC:" -ForegroundColor $Yellow
    Write-Host "  1. MinGW: https://www.mingw-w64.org/" -ForegroundColor White
    Write-Host "  2. Chocolatey: choco install mingw" -ForegroundColor White
    Write-Host "  3. MSYS2: https://www.msys2.org/" -ForegroundColor White
    Write-Host ""
}

# Check Make
Write-Host "Checking Make Tool..." -ForegroundColor $Cyan
$make_found = $null -ne (Get-Command make -ErrorAction SilentlyContinue)

if ($make_found) {
    $make_ver = make --version 2>&1 | Select-Object -First 1
    Write-Host "✓ Make is installed" -ForegroundColor $Green
    Write-Host "  $make_ver" -ForegroundColor $Green
} else {
    Write-Host "✗ Make is NOT installed" -ForegroundColor $Red
    $all_ok = $false
    $missing += "Make"
    
    Write-Host ""
    Write-Host "Installation options for Make:" -ForegroundColor $Yellow
    Write-Host "  1. MinGW: https://www.mingw-w64.org/" -ForegroundColor White
    Write-Host "  2. Chocolatey: choco install make" -ForegroundColor White
    Write-Host "  3. MSYS2: pacman -S make" -ForegroundColor White
    Write-Host "  4. GNUWin32: http://gnuwin32.sourceforge.net/packages/make.htm" -ForegroundColor White
    Write-Host ""
}

# Check Python
Write-Host "Checking Python..." -ForegroundColor $Cyan
$python_found = $null -ne (Get-Command python -ErrorAction SilentlyContinue)

if ($python_found) {
    $python_ver = python --version 2>&1
    Write-Host "✓ Python is installed: $python_ver" -ForegroundColor $Green
    
    # Check Robot Framework
    Write-Host "Checking Robot Framework..." -ForegroundColor $Cyan
    $robot_check = python -c "import robot; print(robot.__version__)" 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Robot Framework is installed (v$robot_check)" -ForegroundColor $Green
    } else {
        Write-Host "✗ Robot Framework is NOT installed" -ForegroundColor $Red
        $all_ok = $false
        $missing += "Robot Framework"
        
        Write-Host ""
        Write-Host "Installation options for Robot Framework:" -ForegroundColor $Yellow
        Write-Host "  1. pip: pip install robotframework" -ForegroundColor White
        Write-Host "  2. conda: conda install -c conda-forge robotframework" -ForegroundColor White
        Write-Host ""
    }
} else {
    Write-Host "✗ Python is NOT installed" -ForegroundColor $Red
    $all_ok = $false
    $missing += "Python"
    
    Write-Host ""
    Write-Host "Installation options for Python:" -ForegroundColor $Yellow
    Write-Host "  1. python.org: https://www.python.org/downloads/" -ForegroundColor White
    Write-Host "  2. Chocolatey: choco install python" -ForegroundColor White
    Write-Host ""
    Write-Host "IMPORTANT: Check 'Add Python to PATH' during installation" -ForegroundColor $Yellow
    Write-Host "After installation, run: pip install robotframework" -ForegroundColor $Yellow
    Write-Host ""
}

# Summary
Write-Host ""
Write-Host "=" * 70 -ForegroundColor $Cyan
Write-Host "Summary" -ForegroundColor $Cyan
Write-Host "=" * 70 -ForegroundColor $Cyan
Write-Host ""

if ($all_ok) {
    Write-Host "✓ All dependencies installed!" -ForegroundColor $Green
    Write-Host ""
    Write-Host "Project is ready to go. Run tests with:" -ForegroundColor $Cyan
    Write-Host "  ./run_tests.bat" -ForegroundColor $Yellow
    Write-Host ""
} else {
    Write-Host "✗ Missing dependencies:" -ForegroundColor $Red
    Write-Host ""
    foreach ($dep in $missing) {
        Write-Host "  - $dep" -ForegroundColor $Red
    }
    Write-Host ""
    Write-Host "Please install the missing dependencies above." -ForegroundColor $Yellow
    Write-Host ""
}
