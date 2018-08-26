
from random import randint
from time import clock
from cos_sim_np import get_cos_sim
import numpy as np

size = 10000
print('Generating 2 vectors of size {} with random values in range -10 to 10'
    .format(size))
vector0 = np.array([randint(-10,10) for x in range(size)])
vector1 = np.array([randint(-10,10) for x in range(size)])

print('Calculating Cosine Similarity. Repeating 100x.'.format(size))
start = clock()
for i in range(100):
    similarity = get_cos_sim(vector0, vector1)
end = clock()
print('Done. Runtime: {} s.'.format(round(end-start, 3)))
