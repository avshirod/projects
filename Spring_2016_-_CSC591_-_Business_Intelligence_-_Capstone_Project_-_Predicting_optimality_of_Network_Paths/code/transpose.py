#a util for trransposing a csv with m*n structure into n*m

import sys
if len(sys.argv) != 3:
    print "usage python transpose.py <inputfile name> <output filename>"
    sys.exit(0)
input_file = sys.argv[1]
output_file = sys.argv[2]

f = open(input_file, 'r')
o = open( output_file, 'wb')

lists = []

for data in f:
    temp = data.rstrip().lstrip()
    #print len(temp)
    lists.append([int(x) for x in temp.split(",")])

#print lists

lists = map(list, zip(*lists))

for list_ in lists:
    string = ''
    for item in list_:
        string += str(item) + ','
    o.write(str(string[:-1]))
    o.write('\n')

