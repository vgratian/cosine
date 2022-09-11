
from math import sqrt

def get_cosine_similarity(A, B):
    """
    Cosine similarity calculates the angle distance between two n dimensional
    vectors. The length of the vectors and therefore the eucledian distance
    between them does not play a role, i.e. if the vectors represent documents,
    a longer documents might be still similar to a shorter one.

    The similarity value is 1 if the vectors are identical (i.e. have the same
    angle), 0 if the are not similar (vectors are perpendicular) and -1 if the
    vectors have opposite directions.
    """

    dot_prod = get_dot_prod(A,B)
    eucl_magn = get_eucl_magn(A,B)
    return dot_prod / eucl_magn if eucl_magn else None

def get_dot_prod(A,B):
    """
    Dot product represents how much to vectors have in common, includes the
    angle and length of these vectors. The value is positive if they have
    some similarity, 0 if there is no similarity at all and negative if they
    are opposite of each other.
    """
    dot_prod = 0
    for a, b in zip(A, B):
        dot_prod += a * b
    return dot_prod


def get_eucl_magn(A,B):
    """
    Eucledian magnitude is the product of the lengths of the two vectors.
    We use this value to normalize the dot product of the vectors and
    neutralize the effect of vector lengths on the final similarity score.
    """
    A_len = 0
    B_len = 0
    for a, b in zip(A,B):
        A_len += a * a
        B_len += b * b
    return sqrt(A_len * B_len)
