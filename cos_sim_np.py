
import numpy as np

def get_cosine_similarity(A, B):

    # Make sure vectors are of equal size
    assert len(A) == len(B), 'Vectors are not of equal size.'

    # Calculate dot product and euclidean magnitude
    dot_prod = A.dot(B)
    eucl_magn = np.linalg.norm(A) * np.linalg.norm(B)

    # Return cosine similarity
    return dot_prod / eucl_magn if eucl_magn else None
