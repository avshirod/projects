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

dirpath = os.getcwd() + "/task3"
plot_path = dirpath + "/plots"
res_filename = dirpath + "/task3.txt"

# op = open(res_filename, 'w')
# op.write("Y \t Intercept (a0) \t s^2 (a0) \t p_val (a0) \t X_i (a1) \t s^2 (a1) \t p_val (a1) \t R^2 \t F value \t p_val (F) \n")

y = data[['Y']]
x = data[header[:-1]]
x = sm.add_constant(x)
model1 = sm.OLS(y,x).fit()
print(model1.summary())

# Multiple regression on independent variables without X3: Y ~ X1, X2, X4, X5
y = data[['Y']]
x1245 = data[['X1', 'X2', 'X4', 'X5']]
x1245 = sm.add_constant(x1245)
model2 = sm.OLS(y,x1245).fit()
print(model2.summary())

# Correlation matrix
corr_mat = pd.DataFrame.corr(data, method='pearson')
print(corr_mat)
print("\nCorrelation Matrix with Significant Correlation")
print(corr_mat[abs(corr_mat) > 0.5])

# Multiple regression on independent variables without X3, X4, X5: Y ~ X1, X2
y = data[['Y']]
x12 = data[['X1', 'X2']]
x12 = sm.add_constant(x12)
# model3 = smf.ols('Y ~ X1 + X2', data = data).fit()
model3 = sm.OLS(y,x12).fit()
print(model3.summary())

y = data[['Y']]
x15 = data[['X1','X5']]
x15 = sm.add_constant(x15)
model_final = sm.OLS(y,x15).fit()
print(model_final.summary())

print("Y = {} + {} * {} + {} * {}".format(model_final.params[0], model_final.params[1], 'X1', model_final.params[2], 'X5'))
print("sigma^2 = {}".format(model_final.mse_total))
print("R^2 = {}".format(model_final.rsquared))
print("F-value = {}".format(model_final.fvalue))

# Q-Q Plot of residuals
result = model_final
residuals = result.resid_pearson
# normal_plot()
qqp = sm.qqplot(residuals, loc=0)
fig_path_qqplot = plot_path + "/qqplot_"
# plt.xlabel(str(val))
plt.ylabel("Y")
plt.title("QQ Plot for Residuals")
# plt.show()
plt.savefig(fig_path_qqplot)
plt.gcf().clear()

# Histogram of Residuals
plt.hist(list(residuals))
fig_path_histres = plot_path + "/histres_"
# plt.xlabel(str(val))
plt.ylabel("Y")
# plt.title("Histogram for Residuals of " + str(val))
plt.savefig(fig_path_histres)
# plt.show()
plt.gcf().clear()

# Chi-square for Residuals
chires = stats.chisquare(residuals)
print(chires)

# Scatter Plot of Residuals
fig_path_scatres = plot_path + "/scat_res"
plt.scatter(list(y.values.flatten()),residuals)
plt.title("ScatterPlot for Residuals of Y")
plt.xlabel("Y")
plt.ylabel("Residuals")
# plt.show()
plt.savefig(fig_path_scatres)