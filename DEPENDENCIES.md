# Mini Bank Project - Setup & Dependencies Guide

## Quick Start

Before running the tests, you must check that all dependencies are installed. 

### Check Dependencies

Run the dependency checker to verify your environment:

```bash
check_dependencies.bat
```

This script will check for:
- **GCC Compiler** - for building the C project
- **Make Tool** - for running the Makefile
- **Python & Robot Framework** - for running integration tests

### Expected Output

If all dependencies are installed, you'll see:

```
[SUCCESS] All dependencies installed successfully!

Project is ready. You can now run tests with:

  .\run_tests.bat
```

If any dependencies are missing, the script will provide installation instructions.

---

## Dependencies

### 1. GCC Compiler

**Windows Installation Options:**

- **MinGW (Recommended)** 
  - Download: https://www.mingw-w64.org/
  - Add to PATH environment variable
  
- **Using Chocolatey**
  ```bash
  choco install mingw
  ```
  
- **Using MSYS2**
  - Download: https://www.msys2.org/
  - Install MinGW-w64 toolchain

**Verify Installation:**
```bash
gcc --version
```

### 2. Make Tool

**Windows Installation Options:**

- **MinGW** (comes bundled with GCC)
  - If you installed MinGW, make is already included

- **Using Chocolatey**
  ```bash
  choco install make
  ```

- **Using MSYS2**
  ```bash
  pacman -S make
  ```

- **GNUWin32**
  - Download: http://gnuwin32.sourceforge.net/packages/make.htm
  - Add to PATH

**Verify Installation:**
```bash
make --version
```

### 3. Python 3.9+

**Windows Installation Options:**

- **python.org (Recommended)**
  - Download: https://www.python.org/downloads/
  - **IMPORTANT**: Check "Add Python to PATH" during installation

- **Using Chocolatey**
  ```bash
  choco install python
  ```

**Verify Installation:**
```bash
python --version
```

### 4. Robot Framework

**Installation (after Python is set up):**

```bash
pip install robotframework
```

Or with conda:
```bash
conda install -c conda-forge robotframework
```

**Verify Installation:**
```bash
robot --version
```

---

## Running Tests

Once all dependencies are installed, run the test suite:

```bash
.\run_tests.bat
```

This will:
1. Build the C project using Make
2. Run the integration tests with Robot Framework
3. Generate test reports in `tests/report.html`

---

## Troubleshooting

### "gcc: command not found"
- GCC is not installed or not in PATH
- Run `check_dependencies.bat` for installation options
- After installing, restart the terminal

### "make: command not found"
- Make tool is not installed or not in PATH
- Run `check_dependencies.bat` for installation options
- After installing, restart the terminal

### "python: command not found"
- Python is not installed or not added to PATH
- During Python installation, ensure you check "Add Python to PATH"
- After installation, restart the terminal

### "ModuleNotFoundError: No module named 'robot'"
- Robot Framework is not installed
- Run: `pip install robotframework`

### PATH Issues After Installation
If tools don't work immediately after installation:
1. Close and reopen your terminal/PowerShell
2. Restart VS Code if using it
3. Run `check_dependencies.bat` again

---

## Project Structure

```
d:\Workspace\Dummy\
├── main.c                    (Main C source)
├── Account/                  (Account module)
├── Transaction/              (Transaction module)
├── Storage/                  (Storage module)
├── Build/                    (Build artifacts)
│   ├── makefile.mk
│   ├── build.bat
│   └── run.bat
├── tests/                    (Robot Framework tests)
│   ├── integration_tests.robot
│   ├── keywords/
│   │   ├── code_injector.py
│   │   ├── build_runner.py
│   │   └── c_code_test_library.py
│   └── run_tests.bat
├── check_dependencies.bat    (Dependency checker)
└── README.md                 (This file)
```

---

## Support

For more information on Robot Framework:
- https://robotframework.org/
- https://robotframework.org/robotframework/#user-guide

For Windows development tools:
- MinGW: https://www.mingw-w64.org/
- Chocolatey: https://chocolatey.org/
- MSYS2: https://www.msys2.org/
