#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define G  0.6 //Gravitational constant  
#define dT 0.2 //Length of timestep 

// New types
// Two dimensional vector
typedef struct{
    double x;
    double y;
} vec2;

// Planet
typedef struct{
    vec2 position;
    vec2 velocity;
    double mass;
} planet;

// Global variables
int num_threads;
int num_planets;
int num_timesteps;
int output;

vec2* forces;
planet* planets;


// Parse command line arguments
void parse_args(int argc, char** argv){
    if(argc != 4){
        printf("Useage: nbody num_timesteps num_threads output\n");
        printf("output:\n");
        printf("0 - One file at end of simulation\n");
        printf("1 - One file for each timestep, with planet positions (for movie)\n");
        exit(-1);
    }
    
    num_timesteps = strtol(argv[1], 0, 10);
    num_threads = strtol(argv[2], 0, 10);
    output = strtol(argv[3], 0, 10);
}

// Reads planets from planets.txt
void read_planets(){

    char* a;
    FILE* file = fopen("planets.txt", "r");
    if(file == NULL){
        printf("'planets.txt' not found. Exiting\n");
        exit(-1);
    }

    char line[200];
    a = fgets(line, 200, file);
    sscanf(line, "%d", &num_planets);

    planets = (planet*)malloc(sizeof(planet)*num_planets);

    for(int p = 0; p < num_planets; p++){
        a = fgets(line, 200, file);
        sscanf(line, "%lf %lf %lf %lf %lf",
                &planets[p].position.x,
                &planets[p].position.y,
                &planets[p].velocity.x,
                &planets[p].velocity.y,
                &planets[p].mass);
    }

    fclose(file);
}

// Writes planets to file
void write_planets(int timestep, int output){
    char name[20];
    if(output == 1){
        int n = sprintf(name, "%04d.dat", timestep);
    }
    else{
        int n = sprintf(name, "planets_out.txt");
    }

    FILE* file = fopen(name, "wr+");

    for(int p = 0; p < num_planets; p++){
        if(output == 1){
            fprintf(file, "%f %f\n",
                    planets[p].position.x,
                    planets[p].position.y);
        }
        else{
            fprintf(file, "%f %f %f %f %f\n",
                    planets[p].position.x,
                    planets[p].position.y,
                    planets[p].velocity.x,
                    planets[p].velocity.y,
                    planets[p].mass);
        }
    }

    fclose(file);
}

// Compute force on p from q
vec2 compute_force(planet p, planet q){
    vec2 force;

    vec2 dist;
    dist.x = q.position.x - p.position.x;
    dist.y = q.position.y - p.position.y;

    double abs_dist= sqrt(dist.x*dist.x + dist.y*dist.y);
    double dist_cubed = abs_dist*abs_dist*abs_dist;

    force.x = G*p.mass*q.mass/dist_cubed * dist.x;
    force.y = G*p.mass*q.mass/dist_cubed * dist.y;

    return force;
}

int main(int argc, char** argv){

    parse_args(argc, argv);

    read_planets();

    forces = (vec2*)malloc(sizeof(vec2)*num_planets);
    
    // Main loop
    for(int t = 0; t < num_timesteps; t++){

        if(output == 1){
            write_planets(t, 1);
        }
        
        // Clear forces
        for(int i = 0; i < num_planets; i++){
            forces[i].x = 0;
            forces[i].y = 0;
        }
        
        // Update forces
        for(int p = 0; p < num_planets; p++){
            for(int q = p+1; q < num_planets; q++){
                vec2 f = compute_force(planets[p], planets[q]);

                forces[p].x += f.x;
                forces[p].y += f.y;

                forces[q].x -= f.x;
                forces[q].y -= f.y;
            }
        }

        // Update positions and velocities
        for(int p = 0; p < num_planets; p++){
            planets[p].position.x += dT * planets[p].velocity.x;
            planets[p].position.y += dT * planets[p].velocity.y;

            planets[p].velocity.x += dT * forces[p].x / planets[p].mass;
            planets[p].velocity.y += dT * forces[p].y / planets[p].mass;
        }
    }

    if(output == 0){
        write_planets(num_timesteps,0);
    }
}
