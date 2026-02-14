// transaction.h
#ifndef TRANSACTION_H
#define TRANSACTION_H

#include "account.h"

int deposit(Account *acc, double amount);
int withdraw(Account *acc, double amount);
int transfer(Account *from, Account *to, double amount);

#endif
