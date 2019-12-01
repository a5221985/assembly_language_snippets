#include <stdio.h>
#include "add42.h"
#include "add.h"
#include "mul.h"

int main()
{
    int result;
    result = add42(30);
    printf("Result: %i\n", result);
    int a = 23;
    int b = 45;
    result = add(a, b);
    printf("%d + %d = %d\n", a, b, result); 
    result = mul(a, b);
    printf("%d x %d = %d\n", a, b, result);
    return 0;
}
