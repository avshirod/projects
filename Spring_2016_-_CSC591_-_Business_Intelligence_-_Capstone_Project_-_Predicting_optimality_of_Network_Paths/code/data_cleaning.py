import fingerprint
import os
from _dbus_bindings import String
import networkx as nx
import difflib
import sys
import ast

#read a graph given the directory path and the filename
def read_file(filename, directory):
    if filename is None:
        return
    output = []
    with open(os.path.join(directory,filename), 'r') as file_name:
        for line in file_name:
            words = [x.strip() for x in line.split('|')]
            for word in words:
                if word != '1' or word != '0':
                    word = ''.join(e for e in word if e.isalnum())
                    output.append(word)
    return output

#makes fingerprint from file for each AS
def make_path_fingerprint(filename, directory, key_map):
    words = read_file(filename, directory)

    if words is None:
        return
    for word in words:
        f = fingerprint.Fingerprinter(word)
        k = f.get_ngram_fingerprint(n=1)
        if k in key_map:
            v = key_map[k]
            v.append(word)
        else:
            v = []
            v.append(word)
            key_map[k] = v

    return key_map

#for each unique fingerprint key, assign a unique number
def assign_numbers(key_map):
    if key_map is None:
        return
    key_assign = 0
    num = {}
    for temp_key in key_map:
        if temp_key not in num:
            num[temp_key] = key_assign
        key_assign += 1
    return num

#given a nodename, key map and id map, return the mapped id for that node
def get_node_id(node_name, key_map, id_map):
    node_name = ''.join(e for e in node_name if e.isalnum())
    #print node_name
    fp = fingerprint.Fingerprinter(node_name)
    k = fp.get_ngram_fingerprint(n=1)
    all_keys = id_map.keys()
    key_to_lookup = k
    if not k in all_keys:
        key_to_lookup = difflib.get_close_matches(k, id_map.keys(), n = 1)
        print key_to_lookup
        key_to_lookup = key_to_lookup[0]
    return id_map[key_to_lookup]

#given a path and graph G, calculate the cost of the path
def get_path_cost(G, path):
    temp_path = path[:-1]
    w = 0
    for i,node in enumerate(temp_path):
        w = w + G.get_edge_data(node, path[i+1])['cost']
    return w
        
#generates the graph for filename using key_map and id_map
def generate_graph(filename, key_map, id_map):
    f = open(filename,'r')
    G = nx.Graph()
    
    for (k,v) in id_map.iteritems():
        G.add_node(v)
    
    for line in f:
        edges = line.split('|')
        n1 = get_node_id(edges[0].strip(), key_map, id_map)
        n2 = get_node_id(edges[1].strip(), key_map, id_map)
        c = int(edges[2].strip())
        G.add_edge(n1, n2, cost = c)
    return G

#returns a boolean for optimality of path in graph G, given a min_w of optimal path in graph G
def check_optimal_path(G, path, min_w):
    temp_path = path[:-1]
    w = 0
    is_optimal = False
    for i,node in enumerate(temp_path):
        dict = G.get_edge_data(node, path[i+1])
        if dict is None:#If no edge is there
            return False
        w = w + dict['cost']
        
    if min_w < w:
        is_optimal = True 
    return is_optimal


#builds the actual feature matrix of path optimality for all paths in path_file
def find_features(G, path_file, key_map, id_map):
    f = open(path_file, 'r')
    paths = []
    i = 0
    for line in f:
        line = line.replace('\n','')
        nodes = line.split('|')
        path = []
        for n in nodes:
            path.append(get_node_id(n.strip(), key_map, id_map))
        source = path[0]
        target = path[(len(path) - 1)]
        #print path
        try:
            shortest_path = nx.shortest_path(G, source, target, weight='cost')
            min_w = get_path_cost(G, shortest_path)
        except:
            #print 'path not found', sys.exc_info()[0]
            paths.append(0)
            continue
        #print 'shortest paths length : ', len(shortest_paths)
        is_short = 0
        is_optimal = check_optimal_path(G, path, min_w)
        #shortest_paths = list(shortest_paths)
        #if path in shortest_paths:
        if is_optimal:
            is_short = 1
        paths.append(min_w)
    return paths


#output is written to "path_optimality.txt"
if __name__ == '__main__':
    path_filename = "./data/paths.txt"
    directory = "./data/train/"
    allFiles = tuple(file1 for file1 in os.listdir(directory))
    key_map = {}
    for filename1 in allFiles:
        key_map = make_path_fingerprint(filename1, directory, key_map)
    
    key_map = make_path_fingerprint('paths.txt', './data/', key_map)
    count_key = 0
    count_value = 0
    for k,v in key_map.iteritems():
        count_key += 1
        for val in v:
            count_value += 1
        #print k, v

    id_map = assign_numbers(key_map)
    features = [] 
    features_file = open('path_optimality.txt','w')
    for filename in allFiles:
        G = generate_graph(os.path.join(directory,filename), key_map, id_map)
        feature = find_features(G, path_filename, key_map, id_map)
        print feature
	feature_str = str(feature)
        features_file.write(feature_str[1:-1])
	features.append(feature)
	features_file.write('\n')
