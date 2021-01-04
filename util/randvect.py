#!/usr/bin/env python3

import sys
import random

size = None
minv = None
maxv = None

try:
    size = int(sys.argv[1])
    minv = int(sys.argv[2])
    maxv = int(sys.argv[3])
except IndexError:
    sys.stderr.write('Required: size, min max\n')
except ValueError as e:
    sys.stderr.write('Invalid argument: {}\n'.format(e))

if size is None or minv is None or maxv is None:
    sys.exit(1)

vector = [random.uniform(minv,maxv) for __ in range(size)]
random.shuffle(vector)

sys.stdout.write('\n'.join(str(x) for x in vector))
sys.stdout.flush()

