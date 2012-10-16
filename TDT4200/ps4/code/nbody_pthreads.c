#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <pthread.h>

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

int portion;
vec2** local_forces;
int counter;
pthread_mutex_t mutex;
pthread_cond_t cond_var;

vec2* forces;
planet* planets;

void barrier() {
    pthread_mutex_lock(&mutex);
    counter++;
    if (counter == num_threads)
    {
        counter = 0;
        pthread_cond_broadcast(&cond_var);
    }
    else
    {
        while (pthread_cond_wait(&cond_var, &mutex) != 0);
    }
    pthread_mutex_unlock(&mutex);
}

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

    FILE* file = fopen("planets.txt", "r");
    if(file == NULL){
        printf("'planets.txt' not found. Exiting\n");
        exit(-1);
    }

    char line[200];
    fgets(line, 200, file);
    sscanf(line, "%d", &num_planets);

    planets = (planet*)malloc(sizeof(planet)*num_planets);

    for(int p = 0; p < num_planets; p++){
        fgets(line, 200, file);
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
        sprintf(name, "%04d.dat", timestep);
    }
    else{
        sprintf(name, "planets_out.txt");
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

void* loop(void* arg)
{
    // Calculate what to calculate :D
    int rank = (long)arg;
    int start_p = portion * rank;
    int end_p;
    if (num_planets >= portion + start_p)
        end_p = portion + start_p;
    else
        end_p = num_planets;

    printf("Hello from rank %d, starting at %d, ending at %d\n", rank, start_p, end_p);

    // Main loop
    for(int t = 0; t < num_timesteps; t++){
        if(output == 1 && rank == 0){
            write_planets(t, 1);
        }
        barrier();

        /* Clear forces
        for(int i = start_p; i < end_p; i++){
            forces[i].x = 0;
            forces[i].y = 0;
        }
        */

        // Update forces
        for(int p = start_p; p < end_p; p++){
            for(int q = p+1; q < num_planets; q++){
                vec2 f = compute_force(planets[p], planets[q]);

                local_forces[rank][p].x += f.x;
                local_forces[rank][p].y += f.y;

                local_forces[rank][q].x -= f.x;
                local_forces[rank][q].y -= f.y;
            }
        }
        barrier();

        // Apply updated forces
        for(int p = start_p; p < end_p; p++)
        {
            forces[p].x = forces[p].y = 0;
            for (int i = 0; i < num_threads; i++)
            {
                forces[p].x += local_forces[i][p].x;
                forces[p].y += local_forces[i][p].y;
            }
        }
        barrier();
        // Update positions and velocities
        for(int p = start_p; p < end_p; p++){
            planets[p].position.x += dT * planets[p].velocity.x;
            planets[p].position.y += dT * planets[p].velocity.y;

            planets[p].velocity.x += dT * forces[p].x / planets[p].mass;
            planets[p].velocity.y += dT * forces[p].y / planets[p].mass;
        }
    }
    return NULL;
}

int main(int argc, char** argv){

    parse_args(argc, argv);

    read_planets();

    forces = (vec2*)malloc(sizeof(vec2)*num_planets);

    local_forces = (vec2**)malloc(sizeof(vec2*)*num_threads);
    for (int i = 0; i < num_threads; i++)
    {
        local_forces[i] = (vec2*)malloc(sizeof(vec2)*num_planets);
        for (int p = 0; p < num_planets; p++)
            local_forces[i][p].x = local_forces[i][p].y = 0;
    }

    pthread_t threads[num_threads-1];
    portion = num_planets / num_threads + 1;

    pthread_mutex_init(&mutex, NULL);
    pthread_cond_init(&cond_var,NULL);

    for (int i = 0; i < num_threads-1; i++)
    {
        pthread_create(&threads[i], NULL, loop, (void*)((long)(i+1)));
    }
    loop(NULL);

    for (int i = 0; i < num_threads-1; i++)
    {
        pthread_join(threads[i], NULL);
    }

    if(output == 0){
        write_planets(num_timesteps,0);
    }
}
