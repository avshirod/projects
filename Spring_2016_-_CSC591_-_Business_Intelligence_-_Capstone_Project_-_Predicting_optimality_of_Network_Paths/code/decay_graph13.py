#takes as an input weights file and gives exponential decay for given graph

import sys
if len(sys.argv) != 3:
    print "usage python decay_13.py <inputfile name> <output filename>"
    sys.exit(0)
input_file = sys.argv[1]
output_file = sys.argv[2]

f = open(input_file, 'r')
o = open( output_file, 'wb')

today = 14
i = 13
for line in f:
    lx = map(int, line.rstrip().split(','))
    l = lx[12]
    if l == -1:
	l = 20
    o.write(str(0.5**(today - i) * l) + ',')
    o.write(str(0.25**(today - i) * l) + ',')
    o.write(str(lx[11]) + ',')
    o.write(str(l))
    o.write('\n')
