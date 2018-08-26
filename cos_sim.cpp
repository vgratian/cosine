
/* Required libraries to use this code:
#include <iostream>
#include <math.h>
*/

class Cos_Sim {
private:
    int size;
    float dot_prod;
    float eucl_magn;
    void get_dot_prod(float*, float*, int);
    void get_eucl_magn(float*, float*, int);
public:
    float value;
    Cos_Sim(float*, float*, int);
};

Cos_Sim::Cos_Sim(float *vect0, float *vect1, int size) {
    // Vectors size can't be 0
    if (size == 0) { throw std::logic_error("Vector size can not be 0."); }
    // Calculate eucledian distance
    get_eucl_magn(vect0, vect1, size);
    // If eucledian distance is 0 skip calculation
    if (eucl_magn == 0)
        value = 0;
    else {
        get_dot_prod(vect0, vect1, size);
        value = dot_prod / eucl_magn;
    }
}

void Cos_Sim::get_dot_prod(float *vect0, float *vect1, int size) {
    dot_prod = 0.0;
    for(int i=0; i<size; i++)
        dot_prod += vect0[i] * vect1[i];
}

void Cos_Sim::get_eucl_magn(float *vect0, float *vect1, int size) {
    float eucl_len0 = 0;
    float eucl_len1 = 0;
    for(int i=0; i<size; i++) {
        eucl_len0 += pow(vect0[i], 2);
        eucl_len1 += pow(vect1[i], 2);
    }
    eucl_magn = sqrt(eucl_len0 * eucl_len1);
}
