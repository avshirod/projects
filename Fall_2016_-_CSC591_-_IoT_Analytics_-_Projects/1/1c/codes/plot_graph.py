import matplotlib.pyplot as plt
import numpy as np
import csv

graph_file = "graph.txt"

lines = [line.rstrip('\n') for line in open(graph_file)]

service_entries = [lines[i:i+11] for i in range(0, len(lines), 12)]

def get_list(s):
	temp = s.split()
	ci_minus = float(temp[0][1:-2])
	ci_plus = float(temp[1][0:-1])
	return [ci_minus, ci_plus]

service_time = [int(entry[0]) for entry in service_entries]
grand_mean_t = [float(entry[1]) for entry in service_entries]
ci_mean_t = np.array([get_list(entry[2]) for entry in service_entries])
grand_mean_t_95 = [float(entry[3]) for entry in service_entries]
ci_mean_t_95 = np.array([get_list(entry[4]) for entry in service_entries])
grand_mean_d = [float(entry[5]) for entry in service_entries]
ci_mean_d = np.array([get_list(entry[6]) for entry in service_entries])
grand_mean_d_95 = [float(entry[7]) for entry in service_entries]
ci_mean_d_95 = np.array([get_list(entry[8]) for entry in service_entries])
mean_p = [float(entry[9]) for entry in service_entries]
ci_p = np.array([get_list(entry[10]) for entry in service_entries])

# Plot for T
axes = plt.gca()
plt.plot(service_time, grand_mean_t)
plt.plot(service_time, ci_mean_t[:,0], linestyle = "--")
plt.plot(service_time, ci_mean_t[:,1], linestyle = "--")
axes.set_xlim([10,18])
plt.xlabel("Service Time")
plt.ylabel("Grand Mean T and CI")
plt.title("Graph for T")
plt.savefig('grand_mean_t.jpg')#, bbox_inches='tight')
plt.plot(service_time, grand_mean_t_95, 'black')
plt.plot(service_time, ci_mean_t_95[:,0], 'y', linestyle = "--")
plt.plot(service_time, ci_mean_t_95[:,1], 'y', linestyle = "--")
# plt.show()
plt.savefig('grand_mean_t_and_t95.jpg')#, bbox_inches='tight')
plt.clf()

# Plot for D
axes = plt.gca()
plt.plot(service_time, grand_mean_d)
plt.plot(service_time, ci_mean_d[:,0], linestyle = "--")
plt.plot(service_time, ci_mean_d[:,1], linestyle = "--")
plt.xlabel("Service Time")
plt.ylabel("Grand Mean D and CI")
plt.title("Graph for D")
axes.set_xlim([10,18])
plt.savefig('grand_mean_d.jpg')#, bbox_inches='tight')
plt.plot(service_time, grand_mean_d_95, 'black')
plt.plot(service_time, ci_mean_d_95[:,0], 'y', linestyle = "--")
plt.plot(service_time, ci_mean_d_95[:,1], 'y', linestyle = "--")
# plt.show()
plt.savefig('grand_mean_d_and_d95.jpg')#, bbox_inches='tight')
plt.clf()

# Plot for P
axes = plt.gca()
plt.plot(service_time, mean_p)
plt.plot(service_time, ci_p[:,0], linestyle = "--")
plt.plot(service_time, ci_p[:,1], linestyle = "--")
plt.xlabel("Service Time")
plt.ylabel("Mean P and CI")
plt.title("Graph for P")
axes.set_xlim([10,18])
# plt.show()
plt.savefig('mean_p.jpg')#, bbox_inches='tight')

with open("stats.csv", 'w') as csvf:
	writer = csv.writer(csvf)
	writer.writerow((str(service_time).strip('[]').split(',')))
	writer.writerow((str(grand_mean_t).strip('[]').split(',')))
	writer.writerow((str(grand_mean_d).strip('[]').split(',')))
	writer.writerow((str(mean_p).strip('[]').split(',')))

'''
Readings for Service Time : 
Grand Mean T : 
CI Mean T : 
Grand Mean of 95%  T : 
CI of Mean 95%  T : 
Grand Mean D : 
CI D : 
Grand Mean of 95%  D : 
CI of Mean 95%  D : 
Mean P : 
CI P : 
'''