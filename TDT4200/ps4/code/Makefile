PATH+=:/share/apps/ffmpeg/bin
FPS=25
BITRATE=1024k
JPGS=$(shell ls *.dat | sed s/\.dat/.jpg/)

all: nbody nbody_openmp nbody_pthreads genplanets

nbody: nbody.c
	gcc -std=c99 -O3 -g -o nbody nbody.c -lm

nbody_pthreads: nbody_pthreads.c
	gcc -std=c99 -O3 -g -o nbody_pthreads nbody_pthreads.c -lm
	
nbody_openmp: nbody_openmp.c
	gcc -std=c99 -O3 -g -o nbody_openmp nbody_openmp.c -lm -fopenmp

genplanets: genplanets.c
	gcc -std=c99 -o genplanets genplanets.c

jpgs: ${JPGS}

movie: planets.mp4

planets.mp4: ${JPGS}
	ffmpeg -y -r ${FPS} -b ${BITRATE} -i %4d.jpg planets.mp4 && ${MAKE} clean
	
%.jpg: %.dat
	echo plot \"$*.dat\" using 1:2 with points | cat gpbatch.txt - | gnuplot > $*.jpg
	-rm -f $*.dat
	
clean:
	-rm -f nbody genplanets nbody_pthreads nbody_openmp *.jpg *.dat
