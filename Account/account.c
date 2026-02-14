#include <stdio.h>
#include "account.h"

Account create_account(int id, double initial_balance)
{
    Account acc;
    acc.id = id;
    acc.balance = initial_balance;
    return acc;
}

int is_valid_account(Account *acc)
{
    if (acc == NULL)
        return 0;

    if (acc->id <= 0)
        return 0;

    return 1;
}

double get_balance(Account *acc)
{
    if (!is_valid_account(acc))
        return -1.0;

    return acc->balance;
}

void set_balance(Account *acc, double new_balance)
{
    if (!is_valid_account(acc))
        return;

    acc->balance = new_balance;
}
