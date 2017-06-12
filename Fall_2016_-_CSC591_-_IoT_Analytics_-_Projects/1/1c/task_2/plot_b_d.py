import matplotlib.pyplot as plt 
import numpy as np 

filename = "temp.txt"
values = np.array([float(line.rstrip('\t\n')) for line in open(filename)])
b = [i for i in range(1,35+1)]

axes = plt.gca()
plt.plot(b, values)
# plt.show()
axes.set_xlim([-1, 36])
plt.xlabel("Queue Size")
plt.ylabel("Grand Mean Retransmission Times")
plt.title("Behavior of D for Varying B")
plt.savefig("d_vs_b.jpg")