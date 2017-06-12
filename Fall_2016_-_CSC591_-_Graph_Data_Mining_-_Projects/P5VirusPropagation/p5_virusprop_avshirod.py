import networkx as nx
import numpy as np
import matplotlib.pyplot as plt

filename = "C:/static.network"
g = nx.read_edgelist(filename)

L = nx.normalized_laplacian_matrix(g)
e = np.linalg.eigvals(L.A)
lambda_1 = max(e)
print("Largest eigenvalue:", lambda_1)
# max(nx.laplacian_spectrum(g))

beta1, beta2 = 0.20, 0.01       # Transmission Probability
delta1, delta2 = 0.70, 0.60     # Healing Probability
k1 = 200                        # No of vaccines

c_vpm = beta1/delta

s = lambda_1 * c_vpm            # Strength of virus
print("Effective Strength: ", s)

# As s < 1, the network is stable.
# 1 (a) Will the infection spread across the network (i.e., result on an epidemic), or will it die quickly?
# It will die quickly

strength = []
for beta in np.arange(0,1,0.01):
    temp_c_vpm = float(beta/ delta1)
    temp_s = lambda_1 * temp_c_vpm
    strength.append(temp_s.real)

print(strength)

plt.plot(np.arange(0,1,0.01), strength)
plt.xlabel("Beta (Transmission Probability")
plt.ylabel("Strength of Virus")
plt.show()

l = len(g)
