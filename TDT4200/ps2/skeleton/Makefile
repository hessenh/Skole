inv_filter : inv_filter.c bmp.o
	mpicc -std=c99 -Wall -o inv_filter inv_filter.c bmp.o
	
bmp.o : bmp.c bmp.h
	gcc -std=c99 -Wall -c -o bmp.o bmp.c
	
run : inv_filter
	qrsh -cwd mpirun -n 4 inv_filter
