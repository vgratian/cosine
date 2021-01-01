#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include "cos_sim.c"

#define BILLION  1000000000.0

int vector_from_file(int size, double *vect, char *filename) {
    int result, i;
    char buf[100];
    FILE *f;

    f = fopen(filename, "r");
    i = 0;
    result = 0;
    while (fgets(buf, 100, f) != NULL) {
        vect[i] = atof(buf);
        i++;
        if (i>size) {
            break;
        }
    }
    fclose(f);
    if (i != size) {
        result = 1;
    }
    return result;
}

int main(int argc, char *argv[]) {

    int size, repeat, i;
    double avg_runtime, similarity;
    char *filename_a, *filename_b;
    struct timespec start, end;

    repeat = atoi(argv[1]);
    size = atoi(argv[2]);
    filename_a = argv[3];
    filename_b = argv[4];

    double *vector_a, *vector_b;
    vector_a = malloc(size * sizeof(*vector_a));
    vector_b = malloc(size * sizeof(*vector_a));

    if (vector_from_file(size, vector_a, filename_a) != 0) {
        printf("error reading [%s]\n", filename_a);
        exit(1);
    }
    if (vector_from_file(size, vector_b, filename_b) != 0) {
        printf("error reading [%s]\n", filename_b);
        exit(1);
    }

    avg_runtime = 0;
    double t;

    for (i=0; i<repeat; i++) {
        clock_gettime(CLOCK_REALTIME, &start);
        similarity = get_cosine_similarity(size, vector_a, vector_b);
        clock_gettime(CLOCK_REALTIME, &end);
        t = (end.tv_sec - start.tv_sec) + ((end.tv_nsec - start.tv_nsec)/BILLION);
        avg_runtime += t;
        //printf("%d\t %.10f\n", i, t);
    }

    avg_runtime /= repeat;

    printf("%.20f %.15f", similarity, avg_runtime);
    return 0;
}
