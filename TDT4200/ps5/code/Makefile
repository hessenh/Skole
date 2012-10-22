PATH+=:/usr/local/cuda/bin
all: mandel_c mandel
mandel: mandel.cu
	nvcc -o mandel mandel.cu -O3 -lm
mandel_c: mandel_c.c
	gcc -o mandel_c mandel_c.c -O3 -Wall -std=c99 -lm
clean:
	-rm -f mandel_c mandel

