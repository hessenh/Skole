#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <math.h>

#define G 0.6

int num_planets;

double mass_min = 100;
double mass_max = 200;
double star_mass_min = 100000;
double star_mass_max = 150000;

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
    
    //Central star
    double star_mass = get_rand(star_mass_min, star_mass_max);
    fprintf(file, "%f %f %f %f %f\n",
            0.0,
            0.0,
            0.0,
            0.0,
            star_mass);

    for(int p = 0; p < num_planets; p++){
        double mass = get_rand(mass_min, mass_max);
        double distance = (p + 1) * 100 + get_rand(0,30) - 15;
        double angle = get_rand(0,6.28);
        double posX = cos(angle) * distance;
        double posY = sin(angle) * distance;
        double velocity = sqrt(G*star_mass/distance);
        double velX = sin(angle) * velocity;
        double velY = -cos(angle) * velocity;
        fprintf(file, "%f %f %f %f %f\n",
                posX, 
                posY,
                velX,
                velY,
                mass);
    }

    fclose(file);
}
