
from cos_sim import Cos_Sim
from random import randint
from time import time

vector0 = []
vector1 = []
size = 1000000
print('Generating 2 vectors of size {} with random values in range -10 to 10'
    .format(size))
for i in range(size):
    vector0.append(randint(-10,10))
    vector1.append(randint(-10,10))

print('Calculating cosine similarity between vectors')
start = time()
similarity = Cos_Sim(vector0, vector1).simil
end = time()
print('Done. Runtime: {} s. Similarity: {}.'.format(
    round(end-start, 3), round(similarity, 5)))
