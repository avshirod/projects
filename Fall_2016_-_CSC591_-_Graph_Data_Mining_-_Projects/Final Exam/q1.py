import networkx as nx
import numpy as np
from scipy.sparse import linalg

g = nx.Graph()
g = nx.read_edgelist('q1edges.txt', nodetype=int)

def get_largest_eigens(graph):
    adj = nx.to_scipy_sparse_matrix(graph, dtype=float)
    eigenvalue, eigenvector = linalg.eigs(adj.T, k=1, which='LR')
    return eigenvalue, eigenvector
# largest = u1.flatten().real

g.A = nx.adjacency_matrix(g)
g.eig = nx.linalg.adjacency_spectrum(g)
lambda_1, mu_1 = get_largest_eigens(g)

def shield_value_score(graph, node):
    eigenval, eigenvec = get_largest_eigens(graph)
    eigenvector = eigenvec.flatten()
    score = 2 * eigenval.real * (eigenvector[node].real ** 2)
    return score
    
def netshield(graph, k):
    lambda_1, mu_1 = get_largest_eigens(graph)
    svs = [shield_value_score(graph, node) for node in graph.nodes()]
    s = []
    while (len(s) < k):
        
        def get_netshield_score(node):
            adj = nx.adjacency_matrix(graph)
            score = svs[node] - 2 * (adj[:,s] * mu_1[s].real) * mu_1[node].real
            return score
        
        scores = np.array([get_netshield_score(node) for node in graph.nodes()])
        scores[s] = -99999
        scores = scores.tolist()
        s.append(scores.index(max(scores)))
    return s
    
k = 3
to_vaccinize = netshield(g, 3)
print("Nodes to Vaccinize = %r" % to_vaccinize)

g_vacc = g.copy()
g_vacc.remove_nodes_from(to_vaccinize)
g_vacc.eig = nx.linalg.adjacency_spectrum(g_vacc)
print("Lambda_1 after Vaccination  = %r" % max(g_vacc.eig))

t = g.copy()
v = [6,7,0]
print("Nodes to Vaccinize = %r" % v)
t.remove_nodes_from(v)
print("Lambda_1 after Vaccination  = %r" % max(nx.linalg.adjacency_spectrum(t)))

'''
Output:
Nodes to Vaccinize = [6, 7, 5]
Lambda_1 after Vaccination  = (1.7320508075688774+0j)
Nodes to Vaccinize = [6, 7, 0]
Lambda_1 after Vaccination  = (1+0j)
'''