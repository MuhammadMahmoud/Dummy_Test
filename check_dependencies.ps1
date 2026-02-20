# Dependency Checker for Mini Bank Project
# Checks for: make, gcc, and Robot Framework
# Provides installation guidance if missing

$ErrorActionPreference = "Continue"

# Color codes for output
$Green = [System.ConsoleColor]::Green
$Red = [System.ConsoleColor]::Red
$Yellow = [System.ConsoleColor]::Yellow
$Cyan = [System.ConsoleColor]::Cyan

function Write-Success {
    param([string]$Message)
    Write-Host "✓ " -ForegroundColor $Green -NoNewline
    Write-Host $Message
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "✗ " -ForegroundColor $Red -NoNewline
    Write-Host $Message
}

function Write-Warning-Custom {
    param([string]$Message)
    Write-Host "⚠ " -ForegroundColor $Yellow -NoNewline
    Write-Host $Message
}

function Write-Header {
    param([string]$Message)
    Write-Host ""
    Write-Host "=" * 70 -ForegroundColor $Cyan
    Write-Host $Message -ForegroundColor $Cyan
    Write-Host "=" * 70 -ForegroundColor $Cyan
}

function Write-Section {
    param([string]$Message)
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $Cyan
    Write-Host $Message -ForegroundColor $Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $Cyan
}

function Test-Command {
    param([string]$Command)
    try {
        $null = Get-Command $Command -ErrorAction SilentlyContinue
        if ($?) {
            return $true
        }
        return $false
    }
    catch {
        return $false
    }
}

function Get-ToolVersion {
    param([string]$Command, [string]$VersionFlag = "--version")
    try {
        $output = & $Command $VersionFlag 2>&1
        if ($output) {
            return ($output | Select-Object -First 1).ToString()
        }
        return "Unknown version"
    }
    catch {
        return "Unable to determine version"
    }
}

# ==================== START CHECKING ====================

Write-Header "Mini Bank Project - Dependency Checker"

$all_installed = $true
$missing_tools = @()

# ==================== CHECK GCC ====================

Write-Section "Checking GCC Compiler"

if (Test-Command "gcc") {
    Write-Success "GCC compiler is installed"
    $version = Get-ToolVersion "gcc" "--version"
    Write-Host "   Version: $version" -ForegroundColor Green
}
else {
    Write-Error-Custom "GCC compiler is NOT installed"
    $all_installed = $false
    $missing_tools += "gcc"
    
    Write-Host ""
    Write-Host "   Installation instructions for GCC:" -ForegroundColor $Yellow
    Write-Host ""
    Write-Host "   Option 1: Using MinGW (Recommended for Windows)" -ForegroundColor $Yellow
    Write-Host "   - Download from: https://www.mingw-w64.org/" -ForegroundColor White
    Write-Host "   - Or use MinGW-w64 from: https://github.com/niXman/mingw-builds-binaries/releases" -ForegroundColor White
    Write-Host "   - Add GCC to PATH environment variable" -ForegroundColor White
    Write-Host ""
    Write-Host "   Option 2: Using Chocolatey (if installed)" -ForegroundColor $Yellow
    Write-Host "   - Run: choco install mingw" -ForegroundColor White
    Write-Host ""
    Write-Host "   Option 3: Using MSYS2" -ForegroundColor $Yellow
    Write-Host "   - Download from: https://www.msys2.org/" -ForegroundColor White
    Write-Host "   - Install MinGW-w64 toolchain" -ForegroundColor White
    Write-Host ""
    Write-Host "   Verify installation by running: gcc --version" -ForegroundColor White
    Write-Host ""
}

# ==================== CHECK MAKE ====================

Write-Section "Checking Make Tool"

if (Test-Command "make") {
    Write-Success "Make tool is installed"
    $version = Get-ToolVersion "make" "--version"
    Write-Host "   Version: $version" -ForegroundColor Green
}
else {
    Write-Error-Custom "Make tool is NOT installed"
    $all_installed = $false
    $missing_tools += "make"
    
    Write-Host ""
    Write-Host "   Installation instructions for Make:" -ForegroundColor $Yellow
    Write-Host ""
    Write-Host "   Option 1: Using MinGW (comes with GCC)" -ForegroundColor $Yellow
    Write-Host "   - MinGW installation above includes make" -ForegroundColor White
    Write-Host "   - Verify: make --version" -ForegroundColor White
    Write-Host ""
    Write-Host "   Option 2: Using Chocolatey" -ForegroundColor $Yellow
    Write-Host "   - Run: choco install make" -ForegroundColor White
    Write-Host ""
    Write-Host "   Option 3: Using MSYS2" -ForegroundColor $Yellow
    Write-Host "   - pacman -S make" -ForegroundColor White
    Write-Host ""
    Write-Host "   Option 4: Download pre-built binaries" -ForegroundColor $Yellow
    Write-Host "   - From: http://gnuwin32.sourceforge.net/packages/make.htm" -ForegroundColor White
    Write-Host "   - Add to PATH environment variable" -ForegroundColor White
    Write-Host ""
}

# ==================== CHECK ROBOT FRAMEWORK ====================

Write-Section "Checking Robot Framework (Python)"

if (Test-Command "python") {
    $python_version = Get-ToolVersion "python" "--version"
    Write-Success "Python is installed: $python_version"
    
    # Check Robot Framework
    $robot_installed = $false
    try {
        $robot_output = python -c "import robot; print(robot.__version__)" 2>&1
        if ($LASTEXITCODE -eq 0 -and $robot_output) {
            $robot_installed = $true
            Write-Success "Robot Framework is installed (v$robot_output)"
        }
    }
    catch {
        # Continue
    }
    
    if (-not $robot_installed) {
        Write-Error-Custom "Robot Framework is NOT installed"
        $all_installed = $false
        $missing_tools += "robot-framework"
        
        Write-Host ""
        Write-Host "   Installation instructions for Robot Framework:" -ForegroundColor $Yellow
        Write-Host ""
        Write-Host "   Option 1: Using pip (Recommended)" -ForegroundColor $Yellow
        Write-Host "   - Run: pip install robotframework" -ForegroundColor White
        Write-Host ""
        Write-Host "   Option 2: Upgrade pip if needed first" -ForegroundColor $Yellow
        Write-Host "   - Run: python -m pip install --upgrade pip" -ForegroundColor White
        Write-Host "   - Then: pip install robotframework" -ForegroundColor White
        Write-Host ""
        Write-Host "   Option 3: Using conda (if installed)" -ForegroundColor $Yellow
        Write-Host "   - Run: conda install -c conda-forge robotframework" -ForegroundColor White
        Write-Host ""
        Write-Host "   Verify installation by running: robot --version" -ForegroundColor White
        Write-Host ""
    }
}
else {
    Write-Error-Custom "Python is NOT installed (required for Robot Framework)"
    $all_installed = $false
    $missing_tools += "python"
    
    Write-Host ""
    Write-Host "   Installation instructions for Python:" -ForegroundColor $Yellow
    Write-Host ""
    Write-Host "   Option 1: Download from python.org" -ForegroundColor $Yellow
    Write-Host "   - Visit: https://www.python.org/downloads/" -ForegroundColor White
    Write-Host "   - Download Python 3.9 or later" -ForegroundColor White
    Write-Host "   - During installation, CHECK the box: 'Add Python to PATH'" -ForegroundColor White
    Write-Host ""
    Write-Host "   Option 2: Using Chocolatey" -ForegroundColor $Yellow
    Write-Host "   - Run: choco install python" -ForegroundColor White
    Write-Host ""
    Write-Host "   After installing Python:" -ForegroundColor $Yellow
    Write-Host "   - Verify: python --version" -ForegroundColor White
    Write-Host "   - Install Robot: pip install robotframework" -ForegroundColor White
    Write-Host ""
}

# ==================== FINAL SUMMARY ====================

Write-Header "Dependency Check Summary"

if ($all_installed) {
    Write-Host ""
    Write-Success "All dependencies are installed and project is ready!"
    Write-Host ""
    Write-Host "✓ GCC compiler" -ForegroundColor $Green
    Write-Host "✓ Make tool" -ForegroundColor $Green
    Write-Host "✓ Robot Framework" -ForegroundColor $Green
    Write-Host ""
    Write-Host "You can now run: ./run_tests.bat" -ForegroundColor $Cyan
    Write-Host ""
}
else {
    Write-Host ""
    Write-Error-Custom "Some dependencies are missing:"
    Write-Host ""
    foreach ($tool in $missing_tools) {
        Write-Host "  - $tool" -ForegroundColor $Red
    }
    Write-Host ""
    Write-Host "Please install the missing dependencies above and run this check again." -ForegroundColor $Yellow
    Write-Host ""
}

Write-Host ""
