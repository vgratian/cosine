
from sklearn.metrics.pairwise import cosine_similarity

def get_cosine_similarity(A, B):
    """
    Equivalent, but about 3x slower method of calculation with sklean

        from sklearn.utils.extmath import safe_sparse_dot
        from sklearn.metrics.pairwise import euclidean_distances
        (...)
        eucl_magn = euclidean_distances([A,O])[0][-1] * euclidean_distances([B,O])[0][-1]
        return safe_sparse_dot(A,B) / eucl_magn if eucl_magn else None
    
    where O is a zero-matrix with same dimensions as A and B.
    """

    return cosine_similarity(A, B)[0][0]
