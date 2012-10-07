#include <stdlib.h>
#include <stdio.h>
#include <time.h>

int num_planets;

double pos_min = -800;
double pos_max = 800;
double vel_min = -10;
double vel_max = 10;
double mass_min = 100;
double mass_max = 10000;

double get_rand(double min, double max){
    return ((double)rand()/(double)RAND_MAX) * (max - min) + min;
}

int main(int argc, char** argv){
    srand(time(NULL));

    if(argc != 2){
        printf("Useage: genplanets num_planets\n");
        exit(-1);
    }

    num_planets = strtol(argv[1], 0, 10);

    FILE* file = fopen("planets.txt", "wr+");

    fprintf(file, "%d\n", num_planets);

    for(int p = 0; p < num_planets; p++){
        fprintf(file, "%f %f %f %f %f\n",
                get_rand(pos_min, pos_max),
                get_rand(pos_min, pos_max),
                get_rand(vel_min, vel_max),
                get_rand(vel_min, vel_max),
                get_rand(mass_min, mass_max));
    }

    fclose(file);
}
