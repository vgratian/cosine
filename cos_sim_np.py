
import numpy

def get_cos_sim(a, b):

    # Make sure vectors are of equal size
    assert len(a) == len(b), 'Vectors are not of equal size.'

    # Calculate cosine similarity between vectors
    dot_prod = a.dot(b)
    eucl_magn = numpy.linalg.norm(a) * numpy.linalg.norm(b)
    return dot_prod / eucl_magn if eucl_magn else None
