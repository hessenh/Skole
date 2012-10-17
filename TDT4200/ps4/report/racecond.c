#include <stdio.h>

int main(void)
{
    int sum = 0;
    #pragma omp parallel for
    for (int i = 0; i < 10; i++)
        sum += i;
    printf("Sum is %d\n", sum);
}


