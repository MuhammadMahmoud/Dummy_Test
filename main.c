#include <stdio.h>
#include "account.h"
#include "transaction.h"
#include "storage.h"

int main()
{
    printf("Mini Bank System Starting...\n");

    Account a1 = create_account(1, 1000.0);
    Account a2 = create_account(2, 500.0);

    deposit(&a1, 200.0);
    withdraw(&a2, 100.0);
    transfer(&a1, &a2, 300.0);

    printf("Account 1 Balance: %.2f\n", get_balance(&a1));
    printf("Account 2 Balance: %.2f\n", get_balance(&a2));

    save_account("a1.dat", &a1);
    save_account("a2.dat", &a2);

    printf("Accounts saved successfully.\n");

    return 0;
}
