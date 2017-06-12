import csv
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import os

filename = 'p2.csv'

'''
# Reading from the csv file (Python 2.7)
with open(filename, 'r') as datafile:
	data = csv.reader(datafile)
	header = next(data, None)
	column = {}
	for h in header:
		column[h] = []
	converters = [str.strip] + [float] * (len(header) - 1)
	for row in data:
		for h, v, conv in zip(header, row, converters):
			column[h].append(conv(v))
'''

data = pd.read_csv(filename)
header = list(data.columns.values)
col_mean = []
col_var = []
for h in header:
	pd.DataFrame.hist(data[[h]])
	plt.title("Histogram for " + h)
	plt.xlabel(h)
	# plt.show()
	plt_name = os.getcwd() + "/task1/histograms/hist_" + h
	plt.savefig(plt_name)
	col_mean.append(pd.DataFrame.mean(data[[h]])[0])
	col_var.append(pd.DataFrame.var(data[[h]])[0])
corr_mat = pd.DataFrame.corr(data, method='pearson')

res_filename = os.getcwd() + "/task1/task1.txt"
with open(res_filename, 'w') as op:
	op.write('Column Means \n')
	op.write(','.join(str(i) for i in col_mean))
	op.write('\n\nColumn Variance \n')
	op.write(','.join(str(i) for i in col_var))
	op.write('\n\nCorrelation Matrix \n')
	op.write(corr_mat.to_string())
# print(col_mean)
# print(col_var)
# print(corr_mat)