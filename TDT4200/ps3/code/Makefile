fft : fft.c
	gcc -std=c99 -lm -lfftw3 -O3 fft.c -o fft

.PHONY: clean

clean:
	rm -f fft

time: fft
	time ./fft 8192 3
