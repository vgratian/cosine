
from math import sqrt

def get_cosine_similarity(A, B):

    a_len = sum( a*a for a in A )
    b_len = sum( b*b for b in B )
    eucl_magn = sqrt(a_len * b_len)
    
    if eucl_magn:
        dot_prod = sum( a*b for a,b in zip(A,B) )
        return dot_prod / eucl_magn
    return None

