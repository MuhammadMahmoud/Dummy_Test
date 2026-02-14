// account.h
#ifndef ACCOUNT_H
#define ACCOUNT_H

typedef struct {
    int id;
    double balance;
} Account;

Account create_account(int id, double initial_balance);
int is_valid_account(Account *acc);
double get_balance(Account *acc);
void set_balance(Account *acc, double new_balance);

#endif
