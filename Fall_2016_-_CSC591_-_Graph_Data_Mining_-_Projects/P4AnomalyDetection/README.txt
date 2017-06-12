CSC 591 - GDM Fall 2016
Project 4 - Anomaly Detection using NetSimile Algorithm
Unity ID - avshirod

--------------------------------------------------------------

The final version of code is in 'anomaly.py'.
To run the program, use command line call to python - 
	> $ python anomaly.py <graph_number>
'graph_number' corresponds to the four time-evolving graphs in datasets obtained from Stanford's SNAP.
The graph_numbers and corresponding datasets are as follows:
1: 'autonomous'
2: 'enron_by_day'
3: 'p2p-Gnutella'
4: 'voices'

So to run the algorithm on 'enron_by_day', you have to run the command - 
	> $ python anomaly.py 2

The output text file with similarity scores is stored in folder 'output' with name of format '<dataset_name>_time_series.txt'.
The anomalies found (if any) are stored in a correspoding manner in the output folder with name '<dataset_name>_anomaly.txt'.

The plots for the scores is stored in 'plots' folder.
You can observe some scores that are above and below the plotted threshold lines. But a graph is considered anomalous if it's similarity scores differ with its previous graph and next graph. As the scores on plot represent score between two graphs (n-1, n), if you spot two successive scores above a threshold level [score for (n-1,n) and score for (n,n+1)], then the common graph at time 'n' is anomalous; and is mentioned in the 'anomaly.txt' file.

Python libraries required:
networkx, numpy, scipy.stats, matplotlib
If Anaconda implementation is used for Python, then the last three are taken care of.
'networkx' can be installed by  - 


Note:
The runtime of algorithm for graphs was observed as follows:
voices < enron_by_day < p2p-Gnutella << autonomous
Output is already stored in corresponding directories. In lieu of time, run on a smaller dataset to experience the program.
