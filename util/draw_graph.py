#!/usr/bin/env python3

import sys
import pprint
import matplotlib.pyplot as plt


data_fp = None
output_fp = None
try:
    data_fp = sys.argv[1]
    output_fp = sys.argv[2]
except IndexError:
    sys.stderr.write('Required arguments: data_fp output_fp\n')
if not data_fp or not output_fp:
    sys.exit(1)

with open(data_fp) as f:
    content = f.readlines()

header = [x.strip() for x in content[0].split()]
data = [[] for project in header]

for line in content[1:]:
    values = [float(x) for x in line.split()]
    for i in range(len(data)):
        data[i].append(values[i])

fig, ax = plt.subplots()
plt.title('Cosine Similarity Benchmark')
plt.xlabel('N (vector size)')
plt.ylabel('T (avg calculate time)')
for i in range(1, len(data)):
    ax.plot(data[0], data[i], label=header[i], linewidth=1.5)
ax.legend(loc='best')
plt.savefig(output_fp+'.png', bbox_inches='tight')

