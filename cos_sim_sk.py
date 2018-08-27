

from sklearn.utils.extmath import safe_sparse_dot
from sklearn.metrics.pairwise import euclidean_distances

def get_cosine_similarity(A,B,O):
    dp = safe_sparse_dot(A,B)
    a_len = euclidean_distances([A,O])[0][-1]
    b_len = euclidean_distances([B,O])[0][-1]
    em = a_len * b_len
    return dp / em if em else None
