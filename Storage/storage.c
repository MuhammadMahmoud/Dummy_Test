#include <stdio.h>
#include "storage.h"

int save_account(const char *filename, Account *acc)
{
    if (!is_valid_account(acc))
        return -1;

    FILE *file = fopen(filename, "wb");
    if (file == NULL)
        return -2;

    fwrite(acc, sizeof(Account), 1, file);
    fclose(file);

    return 0;
}

int load_account(const char *filename, Account *acc)
{
    FILE *file = fopen(filename, "rb");
    if (file == NULL)
        return -1;

    fread(acc, sizeof(Account), 1, file);
    fclose(file);

    return 0;
}

