
# coding: utf-8

# ### Project 4 : Anomaly
# ##### GDM CSC 591 - Fall 2016
# ###### Unity ID: avshirod

# ** Description: **
# 
# This code implements the techniques described in *[NetSimile](https://arxiv.org/pdf/1209.2684.pdf)* paper for Anomaly detection.
# 
# We test the code on four time-evolving graphs taken from [Stanford's SNAP](http://snap.stanford.edu/data/) database.

# In[69]:

# Required Imports
import networkx as nx
import os
import numpy as np
import scipy.stats as sp
import matplotlib.pyplot as plt
import gc
import sys
which_graph = int(sys.argv[1]) - 1


# In[36]:

# Creating a Graph from a file using NetworkX
def createGraph(filename):
    with open(filename, 'rb') as f:
        size_g = next(f, '')   # skip a line
        g = nx.read_edgelist(f, nodetype=int, )
        dim_g = size_g.strip().decode("utf-8").split(" ")
        no_of_nodes, no_of_edges = int(dim_g[0]), int(dim_g[1])
        nodes = g.nodes()
        empty_nodes = list(set(range(no_of_nodes)) - set(nodes))
        g.add_nodes_from(empty_nodes)
        # assert no_of_edges, g.number_of_edges()
        # assert no_of_nodes, g.number_of_nodes()
        # print("Size of Graph : %r " % (size_g.strip().decode("utf-8") ))
    return g


# In[37]:

# Read in all the graphs G_i
# graphs_all has the 4 main graphs; each list item contains a set of graphs
def readGraphs(path):
    print("Reading Graphs from %r" % path.split("\\")[-1])
    filelist = os.listdir(path)
    g = [createGraph(os.path.join(path,filename)) for filename in filelist]
    return g

curr_dir = os.getcwd()
graph_dir = os.path.join(curr_dir,'datasets')
plot_dir = os.path.join(curr_dir,'plots')
graph_folders = os.listdir(graph_dir)
graphs_all = [readGraphs(os.path.join(graph_dir,folder)) for folder in graph_folders[which_graph:which_graph+1]]


# In[38]:

# Get feature_list for one graph
def get_graph_features(g):
    n = nx.number_of_nodes(g)
    features = []
    clustCoeffs = nx.clustering(g)
    for node in range(n):
        deg = g.degree(node) # Feature 1 - Degree of node
        clust_coeff = clustCoeffs[node] # Feature 2 - Clustering Coefficient of node
        egonet_hop1 = nx.ego_graph(g,node)
        egonet_hop2 = nx.ego_graph(g,node,radius=2)
        num_two_hop_nbrs = 0.0
        egonet_clust_coeff = 0.0
        for nbr in g.neighbors(node):
            num_two_hop_nbrs += g.degree(nbr)
            egonet_clust_coeff += clustCoeffs[nbr]
        edges_egonet1 = egonet_hop1.number_of_edges() # Feature 5 - No. of edges in egonet of node
        egonet1_outgoing_edges = 0
        for nbr1 in nx.nodes(egonet_hop1):
            egonet1_outgoing_edges += g.degree(nbr1) - egonet_hop1.degree(nbr1) # Feature 6 - No. of outgoing edges from egonet of node
        num_nbrs_egonet1 = egonet_hop2.number_of_nodes() - egonet_hop1.number_of_nodes() # Feature 7 - No. of neighbours of egonet of node
        if deg!=0:
            avg_num_two_hop_nbrs = num_two_hop_nbrs/deg*1.0 # Feature 3 - Avg No. of two-hop away neighbours for node
            avg_egonet_clust_coeff = egonet_clust_coeff/deg # Feature 4 - Avg Clus Coeff for neighbours of node
        else: 
            avg_num_two_hop_nbrs = 0.0
            avg_egonet_clust_coeff = 0.0
        features.append([deg, clust_coeff, avg_num_two_hop_nbrs, avg_egonet_clust_coeff, edges_egonet1, egonet1_outgoing_edges, num_nbrs_egonet1])
    return features


# In[81]:

# Get F_G_i for all graphs in one main graph
def getFeatures(graphs):
    F_G_i = [get_graph_features(g) for g in graphs]
    return F_G_i

# In[40]:

# Aggregate features for one graph
def aggregate_features(features):
    Fg = list(map(list, zip(*features)))
    fg_mean = [np.mean(feature) for feature in Fg]
    fg_median = [np.median(feature) for feature in Fg]
    fg_std = [np.std(feature) for feature in Fg]
    fg_skew = [sp.skew(feature) for feature in Fg]
    fg_kurtosis = [sp.kurtosis(feature) for feature in Fg]
    signature = [fg_mean, fg_median, fg_std, fg_skew, fg_kurtosis]
    Sg = list(map(list, zip(*signature)))
    return Sg


# In[41]:

# Get S_G_i for all graphs in one main graph
def aggregator(features):
    S_G_i = [aggregate_features for f in features]
    return S_G_i


# In[42]:

# Pairwise similarity function between two adjacent graphs in one main graph
def canberra_distance(p,q):
    return abs(p-q)/(p+q)

flatten = lambda l: [item for sublist in l for item in sublist]

def get_canberra_distance(sign_curr, sign_next):
    total = 0
    sign_n = flatten(sign_curr)
    sign_nplus1 = flatten(sign_next)
    for feature in range(len(sign_n)):
        if sign_n[feature]+sign_nplus1[feature]==0: # To avoid the dividing by zero error
            total += 0
        else:
            total += canberra_distance(sign_n[feature], sign_nplus1[feature])
    return total
    
def compare_scores(signatures):
    scores = [get_canberra_distance(signatures[i], signatures[i+1]) for i in range(len(signatures)-1)]
    return scores


# In[51]:

def netsimile(graphs_all):
    score = []
    for graphs in graphs_all:
        print("------------------ Graph %d ---------------------" % (len(score)+1))
        print("Calculating Features")
        features_g = getFeatures(graphs)
        print("Calculating Signature Vector")
        signatures_g = aggregator(features_g)
        print("Computing Scores")
        scores_g = compare_scores(signatures_g)
        score.append(score_g)
    return scores


# In[53]:

# Running the algorithm
# scores = netsimile(graphs_all[:1])


# In[ ]:
# NetSimile Algorithm for one main graph
def call_netsimile(graphNumber):
    print("Running NetSimile on Graph %d" % (int(graphNumber)+1))
    graph1 = graphs_all[0]
    Sg = []
    print("Calculating Features")
    for graph in graph1:
        Fg = get_graph_features(graph)  # Features
        gc.disable() # Disabling garbage collector to improve speed of list append operation
        Sg.append(aggregate_features(Fg))  # Signatures
        gc.enable()
    print("Calculating Signature Vector")
    score = compare_scores(Sg)  # Scoring
    print("Computing Scores")
    return score


# In[ ]:

# Running algorithm for given graph
score_g = call_netsimile(which_graph)
scores = [score_g]


# In[ ]:

# Storing the output
plot_dir = os.path.join(curr_dir,'plots')
count = 1
for graph_score in scores:
    output_file = '/output/%s_time_series.txt' % graph_folders[which_graph]
    with open(curr_dir+output_file, 'w') as f:
        f.writelines(map(lambda x: str(x)+'\n', graph_score))
    
    median_score = np.median(graph_score)
    M = sum([abs(graph_score[i] - graph_score[i-1]) for i in range(1,len(graph_score))])* 1.0 / (len(graph_score) - 1) 
    print("Median Score = %f \t M = %f" % (median_score, M))
    threshold_upper = median_score + 3*M
    threshold_lower = median_score - 3*M
    
    plt.plot(graph_score,'o')
    plt.axhline(threshold_lower)
    plt.axhline(threshold_upper)
    plt.title("Similarity scores for graphs")
    plt.xlabel("Graphs")
    plt.ylabel("Scores")
    print("Saving Score Plot")
    plt.savefig(os.path.join(plot_dir, '%s_score.png' % graph_folders[which_graph]))
    # plt.savefig('score_%d.png' % count)
    # plt.show()
    
    output_anomaly = 'output/%s_anomaly.txt' % graph_folders[which_graph]
    with open(os.path.join(curr_dir, output_anomaly), 'w') as f:
        for i in range(len(graph_score)-1):
            if  (graph_score[i] > threshold_upper and graph_score[i+1] > threshold_upper) or \
                (graph_score[i] > threshold_upper and graph_score[i+1] < threshold_lower) or \
                (graph_score[i] < threshold_lower and graph_score[i+1] > threshold_upper):
                f.write('G%d\n' % (i+1))
    
    print("Finished Graph %d" % (which_graph+1))
    count+=1