run : inv_filter
#	qrsh -cwd mpirun -n 8 inv_filter
	mpirun -n 8 inv_filter

test: test_inv_filter
#	qrsh -cwd mpirun -n 4 test_inv_filter
	mpirun -n 4 test_inv_filter

test_inv_filter : test.c bmp.o
	mpicc -std=c99 -Wall -o test_inv_filter test.c bmp.o

test.c : inv_filter.c test.in
	sed s/main\(.*\)/main_replaced\(int\ argc,\ char\*\*\ argv\)/ inv_filter.c | cat - test.in > test.c

inv_filter : inv_filter.c bmp.o
	mpicc -std=c99 -Wall -o inv_filter inv_filter.c bmp.o -g
	
bmp.o : bmp.c bmp.h
	gcc -std=c99 -Wall -c -o bmp.o bmp.c

	
clean :
	rm -f *.o test_inv_filter test.c inv_filter 

valgrind: inv_filter
	mpicc -std=c99 -Wall -o inv_filter inv_filter.c bmp.o -g
	PRELOAD=/usr/lib/valgrind/libmpiwrap-amd64-linux.so   \
#	mpirun -n 8 valgrind --leak-check=full --track-origins=yes --show-reachable=yes --suppressions=/usr/share/openmpi/openmpi-valgrind.supp ./inv_filter
	mpirun -n 8 valgrind --suppressions=/usr/share/openmpi/openmpi-valgrind.supp ./inv_filter

gdb:
	mpicc -std=c99 -Wall -o inv_filter inv_filter.c bmp.o -DDebug=0 -g
	mpirun -n 8 inv_filter
