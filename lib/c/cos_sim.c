
#define BILLION 1000000000.0


double inner_prod(double *a, double *z) {
    double value = 0.0;
    while (a != z) {
        value += ( (*a) * (*a) );
        ++a;
    }
    return value;
}

double get_euclidean_magnitude(int size, double *a, double *b) {

    double a_len, b_len;
    int i;

    a_len = inner_prod(a, a+size);
    b_len = inner_prod(b, b+size);

    /*
    for (i=0; i<size; i++) {
        a_len +=(a[i]*a[i]);
    }
    for (i=0; i<size; i++) {
        b_len += (b[i]*b[i]);
    }
    */

    return sqrt(a_len * b_len);
}


double get_dot_product(int size, double *a, double *b) {

    double dot_prod;
    int i;
    
    dot_prod = 0;
    i = 0;
    
    for (i=0; i<size; i++) {
        dot_prod += (a[i] * b[i]);
    }
    return dot_prod;
}


//double get_cosine_similarity(int size, double *a, double *b, double *eucl_t, double *dot_t) {
double get_cosine_similarity(int size, double *a, double *b) {

    double eucl_magn, dot_prod, cos_sim;
    //struct timespec start, end;

    //clock_gettime(CLOCK_REALTIME, &start);
    eucl_magn = get_euclidean_magnitude(size, a, b);
    //clock_gettime(CLOCK_REALTIME, &end);
    //*eucl_t += (end.tv_sec - start.tv_sec) + ((end.tv_nsec - start.tv_nsec)/BILLION);

    //clock_gettime(CLOCK_REALTIME, &start);
    dot_prod = get_dot_product(size, a, b);
    //clock_gettime(CLOCK_REALTIME, &end);
    //*dot_t += (end.tv_sec - start.tv_sec) + ((end.tv_nsec - start.tv_nsec)/BILLION);

    if (eucl_magn == 0.0) {
        cos_sim = 0.0;
    } else {
        cos_sim = dot_prod / eucl_magn;
    }

    return cos_sim;
}
