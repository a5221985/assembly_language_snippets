#include "write.h"

int main()
{
    char *str = "Alhamdulillah!\n";
    int len = 16;
    write(len, str);
    return 0;
}
