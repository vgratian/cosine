
/* Required libraries to use this code:
#include <iostream>
#include <math.h>
*/

class Cosine_Similarity {
private:
    int size;
    float dot_prod;
    float eucl_magn;
    void get_dot_prod(float*, float*, int);
    void get_eucl_magn(float*, float*, int);
public:
    float value;
    Cosine_Similarity(float*, float*, int);
};

Cosine_Similarity::Cosine_Similarity(float *A, float *B, int size) {
    // Vectors size can't be 0
    if (size == 0) { throw std::logic_error("Vector size can not be 0."); }
    // Calculate eucledian distance
    get_eucl_magn(A, B, size);
    // If eucledian distance is 0 skip calculation
    if (eucl_magn == 0)
        value = 0;
    else {
        get_dot_prod(A, B, size);
        value = dot_prod / eucl_magn;
    }
}

void Cosine_Similarity::get_dot_prod(float *A, float *B, int size) {
    dot_prod = 0.0;
    for(int i=0; i<size; i++)
        dot_prod += A[i] * B[i];
}

void Cosine_Similarity::get_eucl_magn(float *A, float *B, int size) {
    float A_len = 0;
    float B_len = 0;
    for(int i=0; i<size; i++) {
        A_len += pow(A[i], 2);
        B_len += pow(B[i], 2);
    }
    eucl_magn = sqrt(A_len * B_len);
}
