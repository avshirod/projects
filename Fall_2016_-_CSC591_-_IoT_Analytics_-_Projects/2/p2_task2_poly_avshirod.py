import csv
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import statsmodels.formula.api as smf
import statsmodels.api as sm
from sklearn import linear_model
import scipy.stats as stats
import os

filename = 'p2.csv'
data = pd.read_csv(filename)
header = list(data.columns.values)
regr = linear_model.LinearRegression()

dirpath = os.getcwd() + "/task2/poly"
res_filename1 = dirpath + "/task2_poly.txt"
op = open(res_filename1, 'w')
op.write("Y \t Intercept (a0) \t s^2 (a0) \t p_val (a0) \t X_i (a1) \t s^2 (a1) \t p_val (a1) \t X_i^2 (a2) \t s^2 (a2) \t p_val (a2) \t R^2 \t F value \t p_val (F) \n")

for val in header[:-1]:
	x1 = data[[val]]
	x1_2 = x1 ** 2
	y = data[['Y']]
	result = smf.ols(formula = "y ~ x1 + x1_2", data=data).fit()
	# print(result.params)
	op.write(str(val) + "\t" + 	str(result.params[0]) + "\t" + str(result.pvalues[0]) + "\t" + str(result.bse[0] ** 2) + "\t" + \
								str(result.params[1]) + "\t" + str(result.pvalues[1]) + "\t" + str(result.bse[1] ** 2) + "\t" + \
								str(result.params[2]) + "\t" + str(result.pvalues[2]) + "\t" + str(result.bse[2] ** 2) + "\t" + \
								str(result.rsquared) + "\t" + str(result.fvalue) + "\t" + str(result.f_pvalue) + "\n")
	# print(result.summary())
	# print(str(result.pvalues[0]) + "\t" + str(result.pvalues[1]))
	# print(result.rsquared)
	# print(str(result.fvalue) + "\t" + str(result.f_pvalue))
	plt.xlabel(str(val))
	plt.ylabel("Y")
	plt.title("Regression Line for " + str(val) + " vs. Y")
	regr.fit(x1,y)
	plt.scatter(x1, y,  color='black')
	plt.plot(x1, regr.predict(x1), color='blue', linewidth=3)
	plt.legend(['Data', 'Fitted Model PolynomialRegression'])
	plt.xticks(())
	plt.yticks(())
	# plt.show()
	fig_path_regline = dirpath + "/polyplots/polyregline_" + val
	plt.savefig(fig_path_regline)
	plt.gcf().clear()

	residuals = result.resid_pearson
	qqp = sm.qqplot(residuals, loc=0)
	fig_path_qqplot = dirpath + "/polyplots/polyqqplot_" + val
	plt.xlabel(str(val))
	plt.ylabel("Y")
	plt.title("QQ Plot for Residuals")
	plt.savefig(fig_path_qqplot)
	plt.gcf().clear()

	# pd.DataFrame.hist(residuals)
	plt.hist(list(residuals))
	fig_path_histres = dirpath + "/polyplots/polyhistres_" + val
	plt.xlabel(str(val))
	plt.ylabel("Y")
	plt.title("Histogram for Residuals of " + str(val))
	plt.savefig(fig_path_histres)
	plt.gcf().clear()

op.write("\nChi-Square Values for Residuals\n\n")
op.write("X_i \t Chi-Square Value \t p-value \n")
for val in header[:-1]:
	x1 = data[[val]]
	x1_2 = x1**2
	y = data[['Y']]
	result = smf.ols(formula = "y ~ x1 + x1_2", data=data).fit()
	residuals = result.resid_pearson
	# print(stats.chisquare(residuals))
	chires = stats.chisquare(residuals)
	op.write(str(val) + "\t" + str(chires[0]) + "\t" + str(chires[1]) + "\n")
	plt.scatter(list(x1.values.flatten()), list(y.values.flatten()), residuals)
	fig_path_scatres = dirpath + "/polyplots/polyscatres_" + val
	plt.xlabel(str(val))
	plt.ylabel("Y")
	plt.title("ScatterPlot for Residuals of " + str(val))
	plt.savefig(fig_path_scatres)
	plt.gcf().clear()

op.close()