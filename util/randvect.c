#include <stdio.h>
#include <stdlib.h>

double get_rand_real(int min, int max) {
    return min + ( rand() / (double) RAND_MAX ) * (max - min);
}

int main(int argc, char *argv[]) {

    long int i, size;
    int min, max;
    double randreal;

    if (argc != 4) {
        printf("required args: size min max\n");
        exit(1);
    }

    size = atol(argv[1]);
    min = atoi(argv[2]);
    max = atoi(argv[3]);

    for (i=0; i<size; i++)
        printf("%.20f\n", get_rand_real(min,max));

    return 0;
}
