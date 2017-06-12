import csv 		# For storing results in csv
import sys 		# For command-line arguments
import math 	# For ceil() function
import random 	# For pseudo-random generator

# class event
class Event:
	def __init__(self, master_clock):
		self.event_type = 1 						# 1 - CLA, 2 - CLS, 3- CLR
		self.system_arrival_time = master_clock 	# MC when request arrived first
		self.time = master_clock					# MC when request next appears in system
		self.queue_arrival_time = 0 				# MC when request got onto queue
		self.service_start_time = 0					# MC when request was served
		self.service_completeion_time = 0			# MC when request was completed
		self.retransmission_times = [] 				# List with times the request was retransmitted
		# print("Arrival Created for " + str(master_clock))

	def retransmitted(self, r_time):
		self.retransmission_times.append(r_time)

	def print_stats(self):
		return str("{},{},{},{},{}".format(self.system_arrival_time, self.queue_arrival_time, self.service_start_time, self.service_completeion_time, self.retransmission_times))

class Simulation:

	'''
	# Data from text file
	inp = {}
	with open('input.txt', 'r') as f:
		data = f.read().splitlines()
		for line in data:
			variable_name = line[0 : line.index(" =")]
			variable_value = int(line[line.index("= ")+2 : ])
			inp[variable_name] = variable_value
		# print(inp)
	first_arrival = inp['first_arrival']
	mean_inter_arrival_time = inp['inter_arrival_time']
	service_time = inp['service_time']
	buffer_size = inp['buffer_size']
	retransmission_delay = inp['retransmission_delay']
	master_clock_limit = inp['master_clock_limit']
	input_devices = inp['input_devices']

	'''
	first_arrival = 0
	mean_inter_arrival_time = float(sys.argv[1])
	mean_retransmission_time = float(sys.argv[2])
	service_time = float(sys.argv[3])
	buffer_size = int(sys.argv[4])
	# number_of_repetitions = sys.argv[5]
	master_clock_limit = float(sys.argv[5])
	input_devices = 200

	next_arrival = first_arrival
	queue = []
	retransmission_list = []

	master_clock = 0
	event_list = []
	devices_processed = []
	# output_string = ""

	# Finding out next arrival time
	# To be modified for Poisson arrivals
	def generate_next_arrival(self):
		# return self.master_clock + self.inter_arrival_time
		return self.master_clock + self.nextTime(self.mean_inter_arrival_time)

	# For creation of a new arrival event
	def add_event(self, time):
		event = Event(time)
		event.system_arrival_time = time
		self.event_list.append(event)

	# Seeing whether current event gets retransmitted or goes in Queue
	def simulate_arrival(self, event):
		if len(self.queue) >= self.buffer_size:
			if event.event_type == 3:
				self.simulate_retransmission(event)
			elif event.event_type == 1:
				self.next_arrival = self.generate_next_arrival()
				# print("Next arrival at " + str(self.next_arrival))
				self.add_event(self.next_arrival)
				self.simulate_retransmission(event)
		else:
			if event.event_type == 3: 
				event.event_type = 2
				self.simulate_servicing(event)
			else:
				event.event_type = 2
				self.simulate_servicing(event)
				self.next_arrival = self.generate_next_arrival()
				# print("Next new arrival at " + str(self.next_arrival))
				self.add_event(self.next_arrival)

	# Retransitting an event
	def simulate_retransmission(self, event):
		event.event_type = 3
		# print("Retransmission event at " + str(self.master_clock))
		# event.retransmitted(self.retransmission_delay)
		self.retransmission_delay = self.nextTime(self.mean_retransmission_time)
		event.time = event.time + self.retransmission_delay
		self.retransmission_list.append(event.time)
		event.retransmission_times.append(self.master_clock)
		self.event_list.append(event)

	# When an event enters Queue
	def simulate_servicing(self, event):
		event.queue_arrival_time = self.master_clock
		if len(self.queue) == 0:
			event.service_start_time = self.master_clock
		else:
			event.service_start_time = self.queue[-1].service_completeion_time
		event.service_completeion_time = event.service_start_time + self.service_time
		event.time = event.service_completeion_time
		self.queue.append(event)
		self.event_list.append(event)

	# When an event leaves Queue
	def simulate_service_completion(self, event):
		self.devices_processed.append(self.queue[0])
		self.queue = list(self.queue[1:])
		# print("Service completion event at " + str(self.master_clock))
		# self.devices_processed += 1

	# Basic simulation function
	def simulate(self):
		if self.master_clock < self.first_arrival:
			# self.add_event(self.first_arrival)
			self.add_event(self.first_arrival)

		self.master_clock = self.event_list[-1].time
		current = self.event_list[-1]
		self.event_list = self.event_list[:-1]
		
		if current.event_type == 2:
			self.simulate_service_completion(current)
		elif current.event_type == 3:
			self.retransmission_list = list(self.retransmission_list[1:])
			self.simulate_arrival(current)
		else:	self.simulate_arrival(current)

		self.event_list.sort(key = lambda x:x.time, reverse = True)

	# Tabular output
	def print_op(self):
		return str("{},{},{},{},{}".format(self.master_clock, self.next_arrival, self.queue[0].service_completeion_time, len(self.queue), self.retransmission_list))
		# print("{} \t {} \t {} \t {} \t {}".format(self.master_clock, self.next_arrival, self.queue[0].service_completeion_time, len(self.queue), self.retransmission_list))
		# self.output_string += "{},{},{},{},{}".format(self.master_clock, self.next_arrival, self.queue[0].service_completeion_time, len(self.queue), str(self.retransmission_list)) + "\n"
		
	# Prints Event List
	def print_event_list(self, event_list):
		for event in event_list:
			print(event.time)

	# Generating random exponential inter-arrival time (Poisson arrivals)
	def generate_exponential(self, arrival_rate):
		return numpy.random.exponential(arrival_rate)

	def pseudo_random(self):
		return random.random()

	# arrival_rate == lambda
	# mean_iat == 1/lambda
	def nextTime(self, mean_iat):
		temp = -math.log(random.random()) * mean_iat
		return temp
		# return float("{0:.2f}".format(temp))
		# return round(Decimal(temp), 2)

def calc_percentile(l, p):
	l_sort = sorted(l)
	return l_sort[math.ceil(p * len(l)/100) - 1]

def mean(l):
	return sum(l)/len(l)

outfile = "output.csv"
statfile = "stat.csv"
s = Simulation()

'''
Output code
# print("Simulation started")
# print("First arrival at " + str(s.first_arrival))
# print("{} \t {} \t {} \t {} \t {}".format(s.master_clock, s.first_arrival, "-", "0", "[]"))

# out_str = ""
# out_str += "{},{},{},{},{}".format(s.master_clock, s.first_arrival, "-", "0", "[]")
'''

# Opening file to write
with open(outfile, 'w', newline='') as tempfile:
	writer = csv.writer(tempfile)
	writer.writerow(('MC', 'CLA', 'CLS', 'Q', 'CLR'))

# Writing to the file, while simulating
with open(outfile, 'a', newline='') as csvfile:
	writer = csv.writer(csvfile)
	s.first_arrival = s.nextTime(s.mean_inter_arrival_time)
	writer.writerow((s.master_clock, format(s.first_arrival, '.2f'), "-", "0", "[]"))
	while s.master_clock <= s.master_clock_limit:
		if(len(s.devices_processed) == s.input_devices):
			break
		s.simulate()
		# x = s.print_op()
		writer.writerow((format(s.master_clock, '.2f'), format(s.next_arrival, '.2f'), \
						format(s.queue[0].service_completeion_time, '.2f') if s.queue else '-', len(s.queue), \
						s.retransmission_list))
						# [format(val, '.2f') for val in s.retransmission_list]))
	#s.print_event_list(s.event_list)