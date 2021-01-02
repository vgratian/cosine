#!/usr/bin/env python3

import sys
import pprint
import matplotlib.pyplot as plt

if len(sys.argv) != 4:
    sys.stderr.write('Required arguments: data_fp output_fp y_label\n')
    sys.exit(1)

data_fp, output_fp, y_label = sys.argv[1:]

with open(data_fp) as f:
    content = f.readlines()

header = [x.strip() for x in content[0].split(',')]
data = [[] for project in header]

for line in content[1:]:
    values = [float(x) for x in line.split(',')]
    for i in range(len(data)):
        data[i].append(values[i])

fig, ax = plt.subplots(figsize=(6,12))
#plt.title()
plt.xlabel('vector size (N)')
plt.ylabel(y_label)
for i in range(1, len(data)):
    ax.plot(data[0], data[i], label=header[i], linewidth=1.5)
ax.legend(loc='best')
#plt.savefig(output_fp+'.png', bbox_inches='tight')
plt.show()

