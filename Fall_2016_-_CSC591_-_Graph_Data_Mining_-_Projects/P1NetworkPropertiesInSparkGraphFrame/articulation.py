# The function should return a DataFrame with two columns, ​id and ​articulation ​, 
# where articulation is a 1 if the node is an articulation point, otherwise a 0.

'''
A vertex in an undirected connected graph is an articulation point (or cut vertex) iff removing it (and edges through it) disconnects the graph. Articulation points represent vulnerabilities in a connected network – single points whose failure would split the network into 2 or more disconnected components. They are useful for designing reliable networks.
For a disconnected undirected graph, an articulation point is a vertex removing which increases number of connected components.
Source: http://www.geeksforgeeks.org/articulation-points-or-cut-vertices-in-a-graph/
'''
def articulations(gframe):
	articulation = {}
	for node in gframe:
		gframe2 = gframe - node
		conn_comp = gframe2.connectedComponents()
		if conn_comp.len >= 2:
			node is articulation point
	return articulation

with open('9_11_edgelist.txt') as terro:
	terrorists = terro.readlines()
	for terrorist in terrorists:
		# Add to GraphFrame
	articulation_points = articulations(<Terrorist_GraphFrame>)
	print(articulation_points)