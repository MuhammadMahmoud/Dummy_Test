# C Code Testing Quick Start

## 1. Prerequisites

```bash
# Verify Robot Framework
robot --version

# Verify Python
python --version

# Verify nmake (Windows)
nmake /?
```

---

## 2. Run All C Code Tests

```bash
cd d:\Workspace\Dummy\tests

python -m robot -P . integration_tests.robot
```

### Expected Output:
```
==============================================================================
C Code Integration Tests
==============================================================================
Test Account Creation And Deposit                            | PASS |
Test Transfer Operation                                      | PASS |
Test File Persistence                                        | PASS |
...
==============================================================================
9 tests, 9 passed, 0 failed
==============================================================================
```

---

## 3. Run Specific Test

```bash
robot -P . -t "Test Account Creation And Deposit" integration_tests.robot
```

---

## 4. View Detailed Logs

```bash
# Debug mode
robot -P . -v LOGLEVEL:DEBUG c_code_integration_tests.robot

# Output HTML report
robot -P . c_code_integration_tests.robot
# Check: report.html, log.html
```

---

## 5. File Structure

```
tests/
├── integration_tests.robot          # Main test file
├── keywords/
│   ├── c_code_test_library.py      # Library wrapper
│   ├── code_injector.py            # Injection engine
│   ├── build_runner.py             # Build engine
└── TEST_GUIDE.md                   # Full documentation
```

---

## 6. How It Works (30-second overview)

```
Robot Test
    ↓
Backup main.c
    ↓
Inject test code (printf statements)
    ↓
Build project (nmake)
    ↓
Run executable
    ↓
Verify output contains expected text
    ↓
Restore original main.c
    ↓
✅ Test passes, main.c unchanged!
```

---

## 7. Troubleshooting

### Error: `robot: command not found`
```bash
python -m robot -P . c_code_integration_tests.robot
```

### Error: `No module named 'keywords'`
```bash
# Must run from tests/ directory
cd d:\Workspace\Dummy\tests
robot -P . c_code_integration_tests.robot
```

### Error: `Build failed`
1. Check nmake installed: `nmake /?`
2. Check makefile.mk exists: `d:\Workspace\Dummy\Build\makefile.mk`
3. Check C files compile manually: `cd Build && nmake -f makefile.mk`

### Error: `Executable not found`
1. Check executable name matches: `main.exe`
2. Check build directory: `d:\Workspace\Dummy\Build`
3. Check build actually completes

---

## 8. Custom Test Template

```robot
My Custom Test
    [Documentation]    What does this test?
    [Setup]    Cleanup After Test
    
    Backup File    d:\\Workspace\\Dummy\\main.c
    
    Inject Code After    d:\\Workspace\\Dummy\\main.c    
    ...    YOUR_STATEMENT_HERE
    ...    printf("\n[VERIFY] your check here\n");
    
    Build And Run
    
    Output Should Contain    [VERIFY] your check here
    
    [Teardown]    Restore All Files
```

---

## 9. Next Steps

1. ✅ Run tests: `robot -P . integration_tests.robot`
2. ✅ Check results
3. ✅ If all pass: You're ready! 🎉
4. ✅ If any fail: Check troubleshooting or logs
5. ✅ Add custom tests for your scenarios

---

## 10. Key Advantages

| Feature | Benefit |
|---------|---------|
| **Dynamic injection** | Test without modifying C files |
| **Actually runs C code** | Tests real behavior, not simulation |
| **Auto restoration** | Files always safe and pristine |
| **Rich verification** | Check any output or side effects |
| **Zero duplication** | Update C = tests auto-update |

---

## Command Reference

```bash
# Full run with report
robot -P . integration_tests.robot

# Specific test
robot -P . -t "Test Name" integration_tests.robot

# Debug mode
robot -P . -v LOGLEVEL:DEBUG integration_tests.robot

# Multiple runs (dryrun first)
robot -P . --dryrun integration_tests.robot
robot -P . integration_tests.robot
```

---

✅ **Ready to test your C code!**

For detailed documentation, see: [TEST_GUIDE.md](TEST_GUIDE.md)
