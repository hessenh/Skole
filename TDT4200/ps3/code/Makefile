fft : fft.c
	gcc -o fft fft.c -std=c99 -lm -I. -L. -lfftw3 -O3 -mssse3 -march=core2 -ffast-math
#	gcc -std=c99 -I. -L. -lm -lfftw3 fft.c -o fft -mssse3 -O3 -march=native -ffast-math


.PHONY: clean

clean:
	rm -f fft

time: fft
	time ./fft 8192 3
