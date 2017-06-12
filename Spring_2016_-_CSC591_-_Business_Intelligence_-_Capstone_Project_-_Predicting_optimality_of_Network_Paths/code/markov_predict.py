#take paths optimality file, outputs a results file using markov chains

import sys, csv
from transition_utils import *

#https://www.kaggle.com/c/facebook-ii/forums/t/3583/the-methods/19403#post19403
#called functions from transition_utils
def get_predictions(data):
	if sum(data) == 0:
		return [ 0 for x in range(0, 3) ]

	transitions = get_transitions(data)
	transition_probs = get_transition_probs(transitions)
	predictions = forecast_three(data[-1], transition_probs)
	return predictions

input_file = open("path_optimality.txt","r")
output_file = open("results.csv","w")

lists = []

for data in input_file:
    temp = data.rstrip()
    lists.append([int(x) for x in temp.split(",")])

#transpose from 15x10000 to 10000x15
lists = map(list, zip(*lists))

periods = [ [] for x in range(0, 3)]

for line in lists:
	line = line[:12]
	line = map(int,line)
	predictions = get_predictions(line)

	for i, period in enumerate(periods):
		period.append(predictions[i])

periods = map(list, zip(*periods))

for i in range(len(lists)):
	lists[i].extend(periods[i])

for list in lists:
	for i in list:
		output_file.write(str(i)+",")
	output_file.write("\n")
