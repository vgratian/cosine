
from time import clock
import cos_sim

size = 50000
print('Generating 2 vectors of size {}. Similarity should be: -1.0.'.format(size))
A = [-10 for x in range(size)]
B = [10 for x in range(size)]

repeat = 50
print('Calculating Cosine Similarity. Repeating {}x.'.format(repeat))
avg_runtime = 0
similarity = None
for i in range(repeat):
    start = clock()
    similarity = cos_sim.get_cosine_similarity(A,B)
    end = clock()
    avg_runtime += (end-start)
avg_runtime = round(avg_runtime / repeat, 4)
print('Done. Average runtime: {} s. Similarity: {}.'.format(avg_runtime,similarity))
