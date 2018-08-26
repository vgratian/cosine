
from random import randint
from time import clock
from cos_sim import Cos_Sim

size = 10000
print('Generating 2 vectors of size {} with random values in range -10 to 10'
    .format(size))
vector0 = [randint(-10,10) for x in range(size)]
vector1 = [randint(-10,10) for x in range(size)]

print('Calculating Cosine Similarity. Repeating 100x.'.format(size))
start = clock()
for i in range(100):
    similarity = Cos_Sim(vector0, vector1).simil
end = clock()
print('Done. Runtime: {} s.'.format(round(end-start, 3)))
