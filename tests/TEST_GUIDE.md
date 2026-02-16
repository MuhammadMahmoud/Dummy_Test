# C Code Integration Tests - Dynamic Code Injection

## Overview

This solution tests **actual C code** by:
1. **Injecting test code** into source files before specific statements
2. **Building** the modified project
3. **Running** the executable and capturing output
4. **Verifying** the output matches expectations
5. **Restoring** original files to pristine state

**No permanent modifications** to your C code!

---

## Architecture

```
Robot Test
    ↓
CCodeTestLibrary (Robot Keywords)
    ↓
┌─────────────────┬──────────────┐
│                 │              │
CodeInjector      BuildRunner    
│                 │              
├─ Backup file   ├─ Build (nmake)
├─ Inject before ├─ Run executable  
├─ Inject after  ├─ Capture output
├─ Restore file  └─ Verify output
└─ Restore all       
    ↓
[Original C files stay unchanged]
[Test results captured and verified]
```

---

## How It Works

### Step 1: Backup Original File

```python
self.injector.backup_file("d:\\Workspace\\Dummy\\main.c")
# Stores original content in memory
```

### Step 2: Inject Test Code

```python
self.injector.inject_after_statement(
    "d:\\Workspace\\Dummy\\main.c",
    'printf("Accounts saved successfully.\\n");',
    'printf("\nTEST PASSED\\n");'
)
```

**Before injection:**
```c
printf("Accounts saved successfully.\n");
```

**After injection:**
```c
printf("Accounts saved successfully.\n");
printf("\nTEST PASSED\n");
```

### Step 3: Build & Run

```python
self.runner.build_and_run("makefile.mk", "main.exe")
# Compiles modified code
# Runs executable
# Captures output to output.txt
```

### Step 4: Verify Output

```python
self.runner.output_contains("TEST PASSED")
# Check if expected text appears in output
```

### Step 5: Restore Original

```python
self.injector.restore_file("d:\\Workspace\\Dummy\\main.c")
# Restores from backup
```

---

## Library Files

### 1. `code_injector.py`
**Purpose:** Inject and restore code

**Key Methods:**
```python
backup_file(file_path)                    # Backup file
inject_before_statement(path, stmt, code) # Inject before
inject_after_statement(path, stmt, code)  # Inject after
restore_file(file_path)                   # Restore single file
restore_all_files()                       # Restore all files
```

### 2. `build_runner.py`
**Purpose:** Build and run C code

**Key Methods:**
```python
build_project(makefile)           # Compile
run_executable(exe_name)          # Execute
build_and_run()                   # Both
get_output()                      # Get output as string
output_contains(text)             # Check output
output_contains_all(*texts)       # All must exist
output_contains_any(*texts)       # At least one exists
```

### 3. `c_code_test_library.py`
**Purpose:** Robot Framework keywords

**Key Keywords:**
```robot
Backup File ${path}
Inject Code Before ${file} ${stmt} ${code}
Inject Code After ${file} ${stmt} ${code}
Restore File ${file}
Restore All Files
Build Project
Run Executable
Build And Run
Output Should Contain ${text}
Output Should Contain All ${text1} ${text2}
Output Should Not Contain ${text}
```

---

## Running Tests

### Run C code integration tests:

```bash
cd d:\Workspace\Dummy\tests

robot -P . integration_tests.robot
```

### Run specific test:

```bash
robot -P . -t "Test Account Creation And Deposit" integration_tests.robot
```

### View detailed output:

```bash
robot -P . -v LOGLEVEL:DEBUG integration_tests.robot
```

---

## Example Test Case

```robot
Test Deposit Increases Balance
    [Documentation]    Verify deposit adds money correctly
    [Setup]    Cleanup After Test
    
    # Step 1: Backup original file
    Backup File    d:\\Workspace\\Dummy\\main.c
    
    # Step 2: Inject test code that outputs verification
    Inject Code After    d:\\Workspace\\Dummy\\main.c    
    ...    deposit(&a1, 200.0);    
    ...    printf("\nDeposit check: A1 balance is %.2f\n", get_balance(&a1));
    
    # Step 3: Build and run
    Build And Run
    
    # Step 4: Verify output
    Output Should Contain    Deposit check: A1 balance is 1200.00
    
    # Step 5: Restore original (automatic with Cleanup)
    Restore File    d:\\Workspace\\Dummy\\main.c
```

**What happens:**
1. `main.c` is backed up to memory
2. Code injected: after `deposit(&a1, 200.0);` add `printf(...)`
3. Project is built (modified code)
4. Executable runs, output captured
5. Verify "Deposit check: A1 balance is 1200.00" in output
6. Original file restored
7. **main.c unchanged!**

---

## Key Features

### ✅ Code Injection

- **Before statement:** Inject code before finding a line
- **After statement:** Inject code after finding a line
- **Clean restoration:** Restores to pixel-perfect original

### ✅ Build & Run

- **Automatic build:** Uses nmake/makefile
- **Output capture:** Saves to `Build/output.txt`
- **Error handling:** Catches build/run failures

### ✅ Output Verification

- **Contains:** Check if text in output
- **Contains All:** Multiple texts must exist
- **Contains Any:** At least one of many texts
- **Line-specific:** Check specific line numbers
- **Not Contains:** Verify absence of text

### ✅ Clean Restoration

- **Automatic:** Restores after each test
- **Backup storage:** Keeps original in memory
- **Batch restore:** `Restore All Files` clears everything

---

## Benefits Over Python Simulation

| Aspect | Python Sim | Code Injection |
|--------|-----------|----------------|
| **Tests** | Simulated logic | Actual C code |
| **Reliability** | Lower | Higher |
| **Updates** | Duplicate effort | Just update C code |
| **Maintenance** | Two codebases | One codebase |
| **Real bugs** | Might miss | Catches all |
| **Speed** | Fast | Slightly slower (build) |

---

## Error Handling

### Statement Not Found

```robot
Inject Code After    d:\\Workspace\\Dummy\\main.c    
...    NONEXISTENT_CODE
```

**Result:** 
```
AssertionError: Statement not found: NONEXISTENT_CODE
```

###Build Failed

```robot
Build And Run
```

**Result:**
```
AssertionError: Build failed
[Shows nmake errors]
```

### Output Mismatch

```robot
Output Should Contain    Expected Text
```

**Result:**
```
AssertionError: Output does not contain 'Expected Text'
Actual output:
[Shows actual output]
```

---

## Best Practices

### 1. Always Backup Before Injecting
```robot
Backup File    d:\\Workspace\\Dummy\\main.c
```

### 2. Use Cleanup in Setup
```robot
[Setup]    Cleanup After Test
```

### 3. Restore After Test
```robot
[Teardown]    Restore All Files
```

### 4. Verify Output Explicitly
```robot
Output Should Contain    Expected text
Output Should Not Contain    Error
```

### 5. Use Descriptive Printf Messages
```c
printf("\n[TEST] Account 1 balance: %.2f\n", get_balance(&a1));
```

---

## Troubleshooting

### Build Fails

1. Check makefile path
2. Verify build directory exists
3. Check makefile syntax
4. Verify C files haven't become corrupted

### Output Not Captured

1. Check `Build/output.txt` exists
2. Verify executable ran successfully
3. Check printf statements exist in code

### Injection Doesn't Work

1. Verify exact statement text (spaces, newlines matter!)
2. Use simple statements (not complex expressions)
3. Check file backup completed

### Files Not Restoring

1. Check `Restore All Files` is called
2. Verify backups were created
3. Check file permissions

---

## Example: Multiple Injections

```robot
Test Multiple Operations
    Backup File    d:\\Workspace\\Dummy\\main.c
    
    Inject Code After    d:\\Workspace\\Dummy\\main.c    
    ...    deposit(&a1, 200.0);
    ...    printf("\n[STEP 1] Deposit complete\n");
    
    Inject Code After    d:\\Workspace\\Dummy\\main.c    
    ...    withdraw(&a2, 100.0);
    ...    printf("[STEP 2] Withdrawal complete\n");
    
    Inject Code After    d:\\Workspace\\Dummy\\main.c    
    ...    transfer(&a1, &a2, 300.0);
    ...    printf("[STEP 3] Transfer complete\n");
    
    Build And Run
    
    Output Should Contain All    [STEP 1]    [STEP 2]    [STEP 3]
    
    Restore All Files
```

---

## Summary

This solution provides:
- ✅ **Test actual C code** (not simulations)
- ✅ **No permanent modifications** (inject, test, restore)
- ✅ **Dynamic test code** (inject at runtime)
- ✅ **Rich verification** (check output)
- ✅ **Clean restoration** (pristine state after)
- ✅ **Zero duplicate effort** (update C code = auto test update)

**Result:** Reliable integration tests of real C code! 🎯

