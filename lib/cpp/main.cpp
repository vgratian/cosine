
#include <iostream>
#include <math.h>
#include <stdlib.h>
#include <ctime>
#include "cos_sim.cpp"

int main() {

    int size = 50000;
    float A[size];
    float B[size];

    std::cout << "Generating 2 vectors of size " << size <<
        " Similarity should be: -1.0." << std::endl;

    for(int i=0; i<size; i++) {
        A[i] = -10.0;
        B[i] = 10.0;
    }

    int repeat = 50;
    std::cout << "Calculating Cosine Similarity. Repeating " << repeat <<
      "x." << std::endl;
    double avg_runtime = 0;
    float similarity;

    for(int i=0; i<100; i++) {
      clock_t start = clock();
      Cosine_Similarity sim (A, B, size);
      similarity = sim.value;
      clock_t end = clock();
      avg_runtime += double(end-start)/CLOCKS_PER_SEC;
    }
    avg_runtime /= repeat;

    printf("Done. Average runtime: %.4gs. Similarity: %.0g.\n", avg_runtime, similarity);
    return 0;
}
