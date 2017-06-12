from pyspark.graphframes import *

%matplotlib inline
import matploblit.pyplot as plt
import networkx as nx

path = "/stanford_graphs/"
filename = "/amazon.graphs.small"
with open(path + filename) as f:
    data = f.readlines()
    for pair in data:
        print(pair)

# Computes degree distribution


def degreedist(gframe):
    degree = []
    count = []
    return degree, count

# GraphFrames represents all graphs as directed, so every edge in the undirected graphs provided or generated must be added twice, once for each direction.

# plt.plot(degree, count)
# nx.fast_gnp_random_graph()
random_graphs = [nx.random_regular_graph(random.randint(2, 20), random.randint(3, 50)) for _ in range(25)]
# Are they scale free?

# Are stanford_graphs scale free?
