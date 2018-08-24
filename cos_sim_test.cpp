
#include <iostream>
#include <math.h>
#include "cos_sim.cpp"
#include <stdlib.h>
#include <ctime>

int main() {

    int size = 10000;
    float vector0[size];
    float vector1[size];

    std::cout << "Generating 2 vectors of size " << size <<
        " with random values in range -10 to 10" << std::endl;

    for(int i=0; i<size; i++) {
        vector0[i] = rand() % 10 + -10;     // random numbers in range -10 to 10
        vector1[i] = rand() % 10 + -10;
    }

    std::cout << "Calculating Cosine Similarity. Repeating 100x." << std::endl;
    clock_t begin = clock();

    for(int i=0; i<100; i++) {
      Cos_Sim sim (vector0, vector1, size);
    }

    clock_t end = clock();

    std::cout << "Done. Runtime: " << double(end-begin)/CLOCKS_PER_SEC
        << " s." << std::endl;
    return 0;
}
