//#include <iostream>
//#include <math.h>

class Cosine_Similarity {
private:
    int size;
    double dot_prod;
    double eucl_magn;
    void get_dot_prod(double*, double*, int);
    void get_eucl_magn(double*, double*, int);
public:
    double value;
    Cosine_Similarity(double*, double*, int);
};

Cosine_Similarity::Cosine_Similarity(double *A, double *B, int size) {
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

void Cosine_Similarity::get_dot_prod(double *A, double *B, int size) {
    dot_prod = 0.0;
    for(int i=0; i<size; i++)
        dot_prod += A[i] * B[i];
}

void Cosine_Similarity::get_eucl_magn(double *A, double *B, int size) {
    double A_len = 0;
    double B_len = 0;
    for(int i=0; i<size; i++) {
        A_len += (A[i] * A[i]);
        B_len += (B[i] * B[i]);
    }
    eucl_magn = sqrt(A_len * B_len);
}
