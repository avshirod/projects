def closeness_centrality(v):
	return 1 / sum([d(u,v) for u in V])

def closeness(gframe):
	# The function should return a DataFrame with two columns: ​id ​and ​closeness
	return closeness

# The network
A-J 1-10
1,2
1,3
1,4
2,1
2,3
2,4
2,5
3,1
3,2
3,4
3,6
3,8
4,1
4,2
4,3
4,5
4,6
4,7
5,2
5,4
5,6
5,7
6,3
6,4
6,5
6,7
6,8
7,4
7,5
7,6
8,3
8,6
8,9
9,8
9,10
10,9