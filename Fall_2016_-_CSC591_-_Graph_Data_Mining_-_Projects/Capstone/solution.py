
# coding: utf-8

# In[1]:

# Required imports
import networkx as nx
import random
import numpy as np
import heapq
import operator


# In[2]:

# Opening file
filename = "twitter_combined.txt"
# filename = "blah.txt"
# filename = 'random_data.txt'
f = open(filename, 'r')
print("Reading Graph")


# In[3]:

edges = [line for line in f]


# In[4]:

f.close()


# In[5]:

# Removing some edges randomly (10%) to create a new snapshot for testing
remove_edges = random.sample(edges, int(len(edges)*0.1))
diff = set(edges) - set(remove_edges)
train = [list(map(int, item.split(' '))) for item in diff]
new_edges = [list(map(int, item.split(' '))) for item in remove_edges]


# In[6]:

# Assign g as a bi-directed graph, like Twitter
g = nx.DiGraph()
g.add_edges_from(train) # Add user connecting edges
print("Adding Edges")


# In[7]:

# Randomly select 'h' number of hashtags (0<h<15) from 50 pre-defined hashtags for each user
# Add these user-hashtag edges to the graph
hashtags = list(range(1,100+1))
with open('add_topics.txt', 'w') as f:
    for node in g.nodes():
        n_topics = random.sample(hashtags, random.randint(0,10))
        for topic_number in n_topics:
            f.write(str(node) + " " + str(topic_number) + "\n")
            g.add_edge(node, topic_number)
print("Adding Hashtags")


# In[8]:

# Compute a score for each non-neighbour of a node based on weighted sum of 7 metrics
metrics = []
# weight = np.array([0.1, 0.25, 0.05, 0.11, 0.12, 0.2, 0.17])
weight = np.array([1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0])
for x in g.nodes():
    metrics_x = []
    for y in g.nodes():
        if not g.has_edge(x,y) and x != y:
            nbrs_x, nbrs_y = set(g.neighbors(x)), set(g.neighbors(y))
            common_neighbors = len(nbrs_x.intersection(nbrs_y))
            jaccard_coeff = (common_neighbors / len(nbrs_x.union(nbrs_y))) if len(nbrs_x.union(nbrs_y)) != 0 else 0
            sorenson_index = (common_neighbors / (len(nbrs_x) + len(nbrs_y))) if (len(nbrs_x) + len(nbrs_y)) != 0 else 0
            salton_cosine_index = (common_neighbors / np.sqrt(len(nbrs_x) * len(nbrs_y))) if np.sqrt(len(nbrs_x) * len(nbrs_y)) != 0 else 0
            hub_depressed_index = (common_neighbors / max(len(nbrs_x), len(nbrs_y))) if max(len(nbrs_x), len(nbrs_y)) != 0 else 0
            adamic_adar_coeff = 0
            resource_allocation = 0
            for node in nbrs_x.intersection(nbrs_y):
                adamic_adar_coeff += 1/np.log(len(g.neighbors(node))) if (len(g.neighbors(node)) != 0 and np.log(len(g.neighbors(node))) != 0) else 0
                resource_allocation += 1/len(g.neighbors(node)) if len(g.neighbors(node)) != 0 else 0
            preferential_attachment = len(nbrs_x) * len(nbrs_y)
            score = np.array([common_neighbors, jaccard_coeff, sorenson_index, salton_cosine_index, hub_depressed_index, adamic_adar_coeff, preferential_attachment])
            metrics_x.append(sum(weight * score))
        else:
            metrics_x.append(-1)
    metrics.append(metrics_x)
print("Computing Metrics")


# In[9]:

# Select top 3 predicted neighbors for each node
top3_topics = []
top3_users = []
nodelist = g.nodes()
for node in metrics:
    # top3.append(list(zip(*heapq.nlargest(3, enumerate(node), key=operator.itemgetter(1))))) # With corr scores
    top_suggested_ids = np.array(list(zip(*heapq.nlargest(50, enumerate(node), key=operator.itemgetter(1))))[0])
    top_suggested = np.array([nodelist[i] for i in top_suggested_ids])
    top3_topics.append(top_suggested[top_suggested <= 100][:3])
    top3_users.append(top_suggested[top_suggested > 100][:3]) 


# In[10]:

# Predicted topics for users
with open('users_top3Topics', 'w') as f:
    for i in range(len(nodelist)):
        f.write(str(nodelist[i]) + " : " + str(top3_topics[i]) + "\n")


# In[11]:

# Categorize the predicted edges between users and hashtags
users = open('users_top3.txt', 'w')
topics = open('topics_top3.txt', 'w')
for node in range(len(nodelist)):
    if nodelist[node] < 100:
        topics.write(str(nodelist[node]) + " " + str(top3_users[node][0]) + "\n")
        topics.write(str(nodelist[node]) + " " + str(top3_users[node][1]) + "\n")
        topics.write(str(nodelist[node]) + " " + str(top3_users[node][2]) + "\n")
    else:
        users.write(str(nodelist[node]) + " " + str(top3_users[node][0]) + "\n")
        users.write(str(nodelist[node]) + " " + str(top3_users[node][1]) + "\n")
        users.write(str(nodelist[node]) + " " + str(top3_users[node][2]) + "\n")
users.close()
topics.close()


# In[12]:

# Checking accuracy
print("Checking Accuracy")
f = open('users_top3.txt', 'r')
predicted = [list(map(int, line.split(' '))) for line in f]
f.close()


# In[13]:

correct = 0
for edge in predicted:
    if edge in new_edges:
        correct += 1


# In[14]:

print("Accuracy : %f" % (correct/len(new_edges)))

