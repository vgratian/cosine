
from math import sqrt

class Cos_Sim:
    """
    Cosine similarity calculates the angle distance between two n dimensional
    vectors. The length of the vectors and therefore the eucledian distance
    between them does not play a role, i.e. if the vectors represent documents,
    a longer documents might be still similar to a shorter one.

    The similarity value is 1 if the vectors are identical (i.e. have the same
    angle), 0 if the are not similar (vectors are perpendicular) and -1 if the
    vectors have opposite directions.
    """

    def __init__(self, vec0, vec1):

        # Make sure vectors are of equal size
        if len(vec0) > len(vec1):
            raise ValueError('Vectors are not of equal size.')

        # Initialize the two vectors
        self.vec0 = vec0
        self.vec1 = vec1

        # Calculate cosine similarity between vectors
        self.dot_prod = self.get_dot_prod()
        self.simil = self.dot_prod / self.get_eucl_magn() if self.dot_prod else 0

    def get_dot_prod(self):
        """
        Dot product represents how much to vectors have in common, includes the
        angle and length of these vectors. The value is positive if they have
        some similarity, 0 if there is no similarity at all and negative if they
        are opposite of each other.
        """
        dot_prod = 0
        for a, b in zip(self.vec0, self.vec1):
            dot_prod += a * b
        return dot_prod

    def get_eucl_magn(self):
        """
        Eucledian magnitude is the product of the lengths of the two vectors.
        We use this value to normalize the dot product of the vectors and
        neutralize the effect of vector lengths on the final similarity score.
        """
        eucl_len0 = 0
        eucl_len1 = 0
        for a, b in zip(self.vec0, self.vec1):
            eucl_len0 += pow(a, 2)
            eucl_len1 += pow(b, 2)
        return sqrt(eucl_len0) * sqrt(eucl_len1)
