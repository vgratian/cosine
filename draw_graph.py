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

#pprint.pprint(data)

#mx = max([x for d in data[1:] for x in d])

#data_a = [1,2,5,8,12,21]
#data_b = [2,3,5,8,11,14]

fig, ax = plt.subplots()
plt.title('Cosine Similarity Benchmark')
plt.xlabel('N (vector size)')
plt.ylabel('T (avg calculate time)')
#plt.axis([data[0][0], data[0][-1], 0, int(mx)+1])
for i in range(1, len(data)):
    print(' >>>>', header[i], data[i])
    ax.plot(data[0], data[i], label=header[i], linewidth=1.5)
#plt.axis([50000,250000,0,3])
#ax.plot([0.0308, 0.0636, 0.0951, 0.1265, 0.1565], label='py_vanilla')
#ax.plot([0.031, 0.0649, 0.0998, 0.1354, 0.1729], label='py_comprh')
#ax.plot([0.02655, 0.062529, 0.078968, 0.106259, 0.155252], label='perl_vanilla')
#ax.plot([0.0064931, 0.0131853, 0.0195255, 0.0259617, 0.0324713], label='cpp_vanilla')
ax.legend(loc='best')
#plt.show()
plt.savefig(output_fp+'.png', bbox_inches='tight')

