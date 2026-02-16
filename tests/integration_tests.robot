*** Settings ***
Documentation     Integration tests for actual C code (mini bank system)
Library           keywords.c_code_test_library.CCodeTestLibrary
Suite Setup       Suite Setup
Suite Teardown    Cleanup After Suite
Test Setup        Cleanup After Test


*** Test Cases ***

Test Program Starts Successfully
    [Documentation]    Verify the program starts and runs without errors
    Build And Run
    Output Should Contain    Mini Bank System Starting
    Output Should Contain    Accounts saved successfully


Test Program Output Contains All Accounts
    [Documentation]    Verify program outputs both account balances
    Build And Run
    Output Should Contain    Account 1 Balance: 900.00
    Output Should Contain    Account 2 Balance: 700.00


Test Program Produces Valid Output Format
    [Documentation]    Verify output has correct format for balances
    Build And Run
    Output Should Contain    Account 1 Balance
    Output Should Contain    Account 2 Balance
    Output Should Contain    Accounts saved successfully


Test Multiple Runs Are Independent
    [Documentation]    First run to verify consistent output
    Build And Run
    Output Should Contain    Account 1 Balance: 900.00
    
    # Second run should produce same output
    Build And Run
    Output Should Contain    Account 1 Balance: 900.00


Test Program Does Not Crash
    [Documentation]    Verify program completes successfully
    Build And Run
    Output Should Not Contain    error
    Output Should Not Contain    Error
    Output Should Not Contain    ERROR


Test Accounts Are Saved To Files
    [Documentation]    Verify save_account functions complete
    Build And Run
    Output Should Contain    Accounts saved successfully


Test Output Contains Required Information
    [Documentation]    Verify all expected information is in output
    Build And Run
    Output Should Contain All    Mini Bank System    Account 1 Balance    Account 2 Balance    Accounts saved


Test Program Logic Correctness
    [Documentation]    Verify the program logic produces correct balances
    Build And Run
    # Initial: A1=1000, A2=500
    # After: deposit(A1, 200), withdraw(A2, 100), transfer(A1->A2, 300)
    # Result: A1=900, A2=700
    Output Should Contain    Account 1 Balance: 900.00
    Output Should Contain    Account 2 Balance: 700.00


*** Keywords ***

Cleanup After Test
    [Documentation]    Cleanup before test
    Restore All Files
