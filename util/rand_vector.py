#!/usr/bin/env python3

import sys
import random

size = None
try:
    size = int(sys.argv[1])
except IndexError:
    sys.stderr.write('Required argument: size\n')
except ValueError as e:
    sys.stderr.write('Invalid size argument: {}\n'.format(e))

if size is None:
    sys.exit(1)

vector = [random.uniform(-10,10) for __ in range(size)]
random.shuffle(vector)

sys.stdout.write('\n'.join(str(x) for x in vector))
sys.stdout.flush()
