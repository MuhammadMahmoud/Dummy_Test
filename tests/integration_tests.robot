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


Test Variable Inputs - Adjust Initial Balances
    [Documentation]    Inject extra deposits after account creation to change initial balances and verify final totals
    Backup File    ../main.c
    Inject Code After    ../main.c    create_account(1, 1000.0);    deposit(&a1, 500.0);
    Inject Code After    ../main.c    create_account(2, 500.0);    withdraw(&a2, 100.0);
    Build And Run
    # Now A1 initial 1500, A2 initial 400; original ops still apply: deposit 200, withdraw 100, transfer 300
    # Calculated: A1: 1500 +200 -300 = 1400.00 ; A2: 400 -100 +300 = 600.00
    Output Should Contain    Account 1 Balance: 1400.00
    Output Should Contain    Account 2 Balance: 600.00
    Restore File    ../main.c


Test Variable Inputs - Change Transaction Amounts
    [Documentation]    Inject extra transactions to alter effective deposit/withdraw/transfer amounts
    Backup File    ../main.c
    Inject Code After    ../main.c    deposit(&a1, 200.0);    deposit(&a1, 300.0);
    Inject Code After    ../main.c    withdraw(&a2, 100.0);    withdraw(&a2, 50.0);
    Inject Code After    ../main.c    transfer(&a1, &a2, 300.0);    transfer(&a1, &a2, 200.0);
    Build And Run
    # Original sequence plus injections: A1:1000 +200 +300 -300 -200 = 1000.00 ; A2:500 -100 -50 +300 +200 = 850.00
    Output Should Contain    Account 1 Balance: 1000.00
    Output Should Contain    Account 2 Balance: 850.00
    Restore File    ../main.c


Test Variable Inputs - Insufficient Funds Scenario
    [Documentation]    Inject a large transfer to trigger insufficient funds handling and verify balance unchanged semantics
    Backup File    ../main.c
    Inject Code After    ../main.c    create_account(2, 500.0);    transfer(&a1, &a2, 10000.0);
    Build And Run
    # Large transfer should fail or be ignored; original final balances remain A1=900, A2=700 (if transfer aborted)
    Output Should Contain    Account 1 Balance: 900.00
    Output Should Contain    Account 2 Balance: 700.00
    Restore File    ../main.c


*** Keywords ***

Cleanup After Test
    [Documentation]    Cleanup before test
    Restore All Files
