// storage.h
#ifndef STORAGE_H
#define STORAGE_H

#include "account.h"

int save_account(const char *filename, Account *acc);
int load_account(const char *filename, Account *acc);

#endif
