# Predicting Optimality of Network Paths
### CSC 591 - Advanced Algorithms for Business Intelligence - Spring 2016


Data is present for 15 timestamps given as graphs and another file containing paths which were optimal for atleast one time stamp, both of them should be in data folder.

1. Binary Markov Model

First run the *data_cleaning.py* to get as output the optimality of each path in 15 input graphs. This will give *path_optimality.txt* as output. (Takes approx 4-6 hours).  
Then run *markov_predict.py*, that contains the code for markov model prediction and will give out a *result.csv* as output. The last three columns in the results.csv are the predicted probabilites for 13, 14 and 15th timestamp.  
After that run *result.py* to get the AUC value as an output.


2. Logistic Regression, Gradient Boosting Machine and Random Forest

For logistic regression, generate the weights of all the paths in training graphs using data_cleaning_1.py. This will generate a file named path_weights.txt.  

Now run: 
```python 
python transpose.py path_weights.txt inter.txt
```

After getting the output, we run the decay.py and decay_13.py, decay_14.py and decay_15.py on inter.txt to get training data and 3 test data sets respectively, using following commands:
``` python
python decay.py inter.txt train.csv
python decay_13.py inter.txt test_13.csv
python decay_14.py inter.txt test_14.csv
python decay_15.py inter.txt test_15.csv
```

Now run the R-code predict.R to get the results for all the 3 models.  

All the intermediate files generated are included in the zip file as it may take some time to run all the code.

Python Dependencies:
Networkx, difflib, ast, re, unicode, scikit (pip install <packages>)

R Dependencies: 
gbm, randomforest, caret
