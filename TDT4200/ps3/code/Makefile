fft : fft.c
	gcc -o fft fft.c -std=c99 -lm -I. -L. -lfftw3 -O3 -march=core2 -ffast-math -fomit-frame-pointer

.PHONY: clean

clean:
	rm -f fft

time: fft
	time ./fft 8192 3

test: fft
	./test.sh
