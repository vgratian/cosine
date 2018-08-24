
from cos_sim import Cos_Sim
from random import randint
from time import clock

vector0 = []
vector1 = []
size = 10000
print('Generating 2 vectors of size {} with random values in range -10 to 10'
    .format(size))
for i in range(size):
    vector0.append(randint(-10,10))
    vector1.append(randint(-10,10))

print('Calculating Cosine Similarity. Repeating 100x.'.format(size))
start = clock()
for i in range(100):
    similarity = Cos_Sim(vector0, vector1).simil
end = clock()
print('Done. Runtime: {} s. Similarity: {}.'.format(round(end-start, 3)))
