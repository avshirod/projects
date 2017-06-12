#code to caluclate exponential decay given the weights file
#12 graphs are used as input here
import sys
if len(sys.argv) != 3:
    print "usage python decay.py <inputfile name> <output filename>"
    sys.exit(0)
input_file = sys.argv[1]
output_file = sys.argv[2]

f = open(input_file, 'r')
o = open( output_file, 'wb')

ls = [i for i in range(1,13)]

today = 13
for line in f:
    l = map(int, line.rstrip().split(','))
    l = l[:12]
    for index in range(len(l)):
	if l[index] == -1:
	    l[index] = 20
    
    o.write(str(sum(0.5**(today - i) * wt for (i, wt) in zip(ls, l))) + ',')
    o.write(str(sum(0.25**(today - i) * wt for (i, wt) in zip(ls, l))) + ',')
    o.write(str(l[11]) + ',')
    o.write(str(sum(l)/12.0))
    o.write('\n')

