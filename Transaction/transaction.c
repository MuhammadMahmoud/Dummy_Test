#include <stdio.h>
#include "transaction.h"

#define SUCCESS 0
#define ERR_INVALID_AMOUNT -1
#define ERR_INSUFFICIENT_FUNDS -2
#define ERR_INVALID_ACCOUNT -3

int deposit(Account *acc, double amount)
{
    if (!is_valid_account(acc))
        return ERR_INVALID_ACCOUNT;

    if (amount <= 0)
        return ERR_INVALID_AMOUNT;

    acc->balance += amount;
    return SUCCESS;
}

int withdraw(Account *acc, double amount)
{
    if (!is_valid_account(acc))
        return ERR_INVALID_ACCOUNT;

    if (amount <= 0)
        return ERR_INVALID_AMOUNT;

    if (acc->balance < amount)
        return ERR_INSUFFICIENT_FUNDS;

    acc->balance -= amount;
    return SUCCESS;
}

int transfer(Account *from, Account *to, double amount)
{
    if (!is_valid_account(from) || !is_valid_account(to))
        return ERR_INVALID_ACCOUNT;

    if (withdraw(from, amount) != SUCCESS)
        return ERR_INSUFFICIENT_FUNDS;

    deposit(to, amount);
    return SUCCESS;
}
