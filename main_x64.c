#include <stdio.h>
#include "add_x64.h"

int main()
{
    long result;
    long a = 23;
    long b = 45;
    result = add_x64(a, b);
    printf("%ld + %ld = %ld\n", a, b, result); 
    return 0;
}
