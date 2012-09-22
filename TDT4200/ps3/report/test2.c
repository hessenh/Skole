#include <stdio.h>

int main() {
    int N = 1000000;
    int a[N];
    for (int i = 0; i < N; i++)
    {
	if (i % 2 == 0)
	    a[i] = 2;
	else
	    a[i] = 0;
//	printf("a[%d] = %d\n", i, a[i]);
    }
}

