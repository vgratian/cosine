
import numpy as np

def get_cosine_similarity(a, b):
    eucl_magn = np.linalg.norm(a) * np.linalg.norm(b)
    return a.dot(b) / eucl_magn if eucl_magn else None
