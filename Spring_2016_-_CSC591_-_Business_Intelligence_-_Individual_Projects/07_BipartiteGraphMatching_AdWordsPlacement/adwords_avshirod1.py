import csv
import random
import collections
import sys
import math

if len(sys.argv) != 2:
    print("Please follow the syntax - 'python adwords.py greedy' or 'python adwords.py balance' or 'python adwords.py msvv'")
    exit(1)
type = sys.argv[1]

bidderBudget = [-1]*100
bidderDict = collections.defaultdict(list)
with open('bidder_dataset.csv', 'r') as bidderCSV:
	has_header = csv.Sniffer().has_header(bidderCSV.read(1024))
	bidderCSV.seek(0)
	bidderData = csv.reader(bidderCSV)
	if has_header:
		next(bidderData)
		ad_id = -1
	for row in bidderData:
		if int(row[0]) != ad_id:
			ad_id = int(row[0])
			bidderBudget[ad_id] = float(row[3])
		bidderDict[row[1]].append((ad_id, float(row[2])))

def greedy(neighbours, budgets, queries):
	revenue = 0
	for q in queries:
		q = q.strip()
		# Discussed with 'cpancha, sgandhi, rshah3'
		ad = [x if budgets[x[0]] - x[1] >= 0 else (-1, -1) for x in neighbours[q]]
		ad1 = [(-1,-1)] * len(ad)
		if ad == ad1: continue
		maxBid = max([x[1] for x in ad])
		revenue += maxBid
		budgets[ad[[i for i, v in enumerate(ad) if v[1] == maxBid][0]][0]] -= maxBid
	return revenue

def mssv(neighbours, budgets, queries):
	revenue = 0
	for q in queries:
		q = q.strip()
		ad = [x if budgets[x[0]] - x[1] >= 0 else (-1, -1) for x in neighbours[q]]
		ad1 = [(-1,-1)] * len(ad)
		if ad == ad1: continue
		chiValue = list(ad)
		chiValue = map(lambda x: (1 - math.exp(-1 * float(budgets[x[0]])/bidderBudget[x[0]])) * x[1], chiValue)
		k = chiValue.index(max(chiValue))
		revenue += ad[k][1]
		budgets[ad[k][0]] -= ad[k][1]
	return revenue

def balance(neighbours, budgets, queries):
	revenue = 0
	for q in queries:
		q = q.strip()
		ad = [x if budgets[x[0]] - x[1] >= 0 else (-1, -1) for x in neighbours[q]]
		ad1 = [(-1, -1)] * len(ad)
		if ad == ad1: continue
		budgetCopy = [budgets[x[0]] if x[0] != -1 else -1 for x in ad]
		maxBid = budgetCopy.index(max(budgetCopy))
		revenue += ad[maxBid][1]
		budgets[ad[maxBid][0]] -= ad[maxBid][1]
	return revenue

def main(type, incomingQueries):
	OPT = sum(bidderBudget)
	total = 0
	with open(incomingQueries, 'r') as f:
		queries = f.readlines()
	if type == 'greedy':
		for i in range(100):
			budgetCopy = bidderBudget[:]
			total += greedy(bidderDict, budgetCopy, queries)
			random.shuffle(queries)
			# print(budgetCopy)
			# print(sum(budgetCopy))
			# print(total)
		total /= 100
		print(total, total/OPT)

	elif type == 'mssv':
		for i in range(100):
			budgetCopy = bidderBudget[:]
			total += mssv(bidderDict, budgetCopy, queries)
			random.shuffle(queries)
		total /= 100
		print(total, total/OPT)

	elif type == 'balance':
		for i in range(100):
			budgetCopy = bidderBudget[:]
			total += balance(bidderDict, budgetCopy, queries)
			random.shuffle(queries)
		total /= 100
		print(total, total/OPT)

main(type, 'queries.txt')


''' Other code - Yet to debug 

import sys
import csv
import math
import random
import collections

queryGraph = {}
advBudget = {}
# advertiserID_i, queries_q, bid_iq, budget_bi
# bidder_dataset.csv
OPT = 0.0
with open('bidder_dataset.csv', 'r') as csvfile:
  header = csv.Sniffer().has_header(csvfile.read(1024))
  csvfile.seek(0)
  bidderData = csv.reader(csvfile)
  if(header):
    next(bidderData)
  advertiserID_i = -1
  for row in bidderData:
    # print(', '.join(row))
    if int(row[0]) != advertiserID_i:
      # print(int(row[0]), row[3], advertiserID_i, row[1])
      advertiserID_i, queries_q, bid_iq = int(row[0]), row[1].strip(), float(row[2])
      if not (row[3] == ''):
        budget_bi = float(row[3])
        advBudget[advertiserID_i] = budget_bi
        OPT += budget_bi
    else: queries_q, bid_iq = row[1], float(row[2])
    #if (advertiserID_i not in advBudget):
      #advBudget[advertiserID_i] = budget_bi
    if (queries_q in queryGraph):
      queryGraph[queries_q].append((advertiserID_i, bid_iq))
    else: queryGraph[queries_q] = [(advertiserID_i, bid_iq)]

advBudgetBackup = dict(advBudget)
# print(OPT)
# queries.txt
# Calculate revenue and competitive ratio (min(ALG/OPT)) (ALG - Mean std revenue over 100 random repetitions of queries, OPT - Optimal matching)

with open('queries1.txt', 'r') as qfile:
  q = qfile.readlines()

def greedy():
  revenue = 0
  for query in q:
    query = query.strip()
    if(not(exhaustBudget(query))):
      revenue += matchNeighbourGreedy(query)
  return revenue

def msvv():
  revenue = 0
  advBudgetCopy = dict(advBudget)
  for query in q:
    query = query.strip()
    if(not(exhaustBudget(query))):
      revenue += matchNeighbourMSVV(query, advBudgetCopy)
  return revenue

def balance():
  revenue = 0
  for query in q:
    query = query.strip()
    if(not(exhaustBudget(query))):
      revenue += matchNeighbourBalance(query)
  return revenue

def exhaustBudget(query):
  qneighbours = queryGraph[query]
  adv, bids = map(list, zip(*qneighbours))
  budget = [advBudget[a] for a in adv]
  # print(budget)
  if sum(budget) == 0: 
    return True
    # print("Budget Exhausted")
  return False

def matchNeighbourGreedy(query):
  qneighbours = queryGraph[query]
  adv, bids = map(list, zip(*qneighbours))
  maxBid = max(bids)
  maxBidAdvID = adv[bids.index(maxBid)]
  # ptr = 1
  if not (advBudget[maxBidAdvID] <= maxBid):
    advBudget[maxBidAdvID] -= maxBid
  #else: 
   # indargs = [i for i,a in enumerate(bids) if a==maxBid]
    #if not (ptr >= len(indargs)):
     # newMaxBidAdvID = bids[indargs[ptr]]
      #advBudget[newMaxBidAdvID] -= maxBid
      #ptr+=1
  
  # print(qneighbours)
  # print(adv)
  # print(bids)
  # print(maxBidAdvID, maxBid)
  # print(advBudget)
  return maxBid

def matchNeighbourMSVV(query, advBudgetCopy):
  qneighbours = queryGraph[query]
  adv, bids = map(list, zip(*qneighbours))
  spentBudget = [advBudget[a] for a in adv]
  originalBudget = [advBudgetCopy[a] for a in adv]
  fracBudgetSpent = [((original-spent)/original) for original,spent in zip(originalBudget, spentBudget)]
  chiBudget = [(1 - math.exp(xi - 1)) for xi in fracBudgetSpent]
  msvvValues = [(bi * chiValue) for bi,chiValue in zip(bids,chiBudget)]
  maxMSVVValue = max(msvvValues)
  maxMSVVValueAdvID = adv[msvvValues.index(maxMSVVValue)]
  advBudget[maxMSVVValueAdvID] -= bids[msvvValues.index(maxMSVVValue)]
  return bids[msvvValues.index(maxMSVVValue)]

def matchNeighbourBalance(query):
  qneighbours = queryGraph[query]
  adv, bids = map(list, zip(*qneighbours))
  budget = [advBudget[a] for a in adv]
  maxUnspentBudget = max(budget)
  maxUnspentBudgetAdvID = adv[budget.index(maxUnspentBudget)]
  advBudget[maxUnspentBudgetAdvID] -= bids[budget.index(maxUnspentBudget)]
  return bids[budget.index(maxUnspentBudget)]
  # for a in adv:
  #   budget.append(advBudget[a])

total = 0
random.seed(0)
if(sys.argv[1] == "greedy"):
  for i in range(100):
    advBudget = dict(advBudgetBackup)
    total += greedy()
    random.shuffle(q)
    # print(advBudget)
    blah = [advBudget[a] for a in advBudget]
    # print(advBudget)
    # print("Total rem budget = ", sum(blah))
    # print("Total revenue = ", total)
  total /= 100
  print(total, total/OPT)
elif (sys.argv[1] == "msvv"):
  for i in range(100):
    advBudget = dict(advBudgetBackup)
    total += msvv()
    random.shuffle(q)
  total /= 100
  print(total, total/OPT)
elif (sys.argv[1] == "balance"):
  for i in range(100):
    advBudget = dict(advBudgetBackup)
    total += balance()
    random.shuffle(q)
  total /= 100
  print(total, total/OPT)
else:
  print("Please follow the syntax - 'python adwords.py greedy' or 'python adwords.py balance' or 'python adwords.py msvv'")
  exit(1)

'''