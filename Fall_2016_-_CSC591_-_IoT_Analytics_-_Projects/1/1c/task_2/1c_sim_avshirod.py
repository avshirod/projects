import csv 		# For storing results in csv
import sys 		# For command-line arguments
import math 	# For ceil() function
import random 	# For pseudo-random generator
# from decimal import Decimal 	# For precision of clock times
# import numpy as np	# For Standard Deviation

# class event
class Event:
	def __init__(self, master_clock):
		self.event_type = 1 						# 1 - CLA, 2 - CLS, 3- CLR
		self.system_arrival_time = master_clock 	# MC when request arrived first
		self.time = master_clock					# MC when request next appears in system
		self.queue_arrival_time = 0 				# MC when request got onto queue
		self.service_start_time = 0					# MC when request was served
		self.service_completion_time = 0			# MC when request was completed
		self.retransmission_times = [] 				# List with times the request was retransmitted

	def retransmitted(self, r_time):
		self.retransmission_times.append(r_time)

	def print_stats(self):
		return str("{},{},{},{},{}".format(self.system_arrival_time, self.queue_arrival_time, self.service_start_time, self.service_completion_time, self.retransmission_times))

class Simulation:

	# Defaults Values
	first_arrival = 0
	mean_inter_arrival_time = 17.98
	mean_retransmission_time = 10
	service_time = 11
	buffer_size = 5
	number_of_repetitions = 50
	master_clock_limit = 100000
	input_devices = 1000

	'''
	# Data from text file
	inp = {}
	with open('input.txt', 'r') as f:
		data = f.read().splitlines()
		for line in data:
			variable_name = line[0 : line.index(" =")]
			variable_value = float(line[line.index("= ")+2 : ])
			inp[variable_name] = variable_value
		# print(inp)
	first_arrival = inp['first_arrival']
	mean_inter_arrival_time = inp['mean_inter_arrival_time']
	mean_retransmission_time = inp['mean_retransmission_time']
	service_time = inp['service_time']
	buffer_size = int(inp['buffer_size'])
	master_clock_limit = int(inp['master_clock_limit'])
	number_of_repetitions = int(inp['number_of_repetitions'])
	input_devices = inp['input_devices']
	random_seed = 0
	'''
	# Command line input
	if (len(sys.argv) > 1):
		# first_arrival = 0
		mean_inter_arrival_time = float(sys.argv[1])
		service_time = float(sys.argv[2])
		mean_retransmission_time = float(sys.argv[3])
		buffer_size = int(sys.argv[4])
		number_of_repetitions = int(sys.argv[5])
		# master_clock_limit = 100000
		# input_devices = 1000
	# else:
	# 	print("Using Default Input.")
	# 	print("Please give command line input in following order :\nMean Inter Arrival Time, Service Time, Mean Retransmission Time, "\
	# 																"Buffer Size, Number of Repetitions\n")

	next_arrival = first_arrival
	queue = []
	retransmission_list = []

	master_clock = 0.0
	event_list = []
	devices_processed = []

	# Finding out next arrival time
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
		# Queue is full, device is retransmitted
		if len(self.queue) >= self.buffer_size:
			if event.event_type == 3:
				self.simulate_retransmission(event)
			elif event.event_type == 1:
				self.next_arrival = self.generate_next_arrival()
				# print("Next arrival at " + str(self.next_arrival))
				self.add_event(self.next_arrival)
				self.simulate_retransmission(event)
		else: # Queue is not full, device enters the queue
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
			event.service_start_time = self.queue[-1].service_completion_time
		event.service_completion_time = event.service_start_time + self.service_time
		event.time = event.service_completion_time
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
		if self.master_clock < self.first_arrival: 	# Generate First Arrival
			self.add_event(self.first_arrival)

		self.master_clock = self.event_list[-1].time
		current = self.event_list[-1]
		self.event_list = self.event_list[:-1]
		
		if current.event_type == 2:					# CLS
			self.simulate_service_completion(current)
		elif current.event_type == 3:				# CLR
			self.retransmission_list = list(self.retransmission_list[1:])
			self.simulate_arrival(current)
		else:	self.simulate_arrival(current)		# CLA

		# Keeping the event list sorted (In reverse order for performance issues)
		self.event_list.sort(key = lambda x:x.time, reverse = True)

	# Tabular output
	def print_op(self):
		return str("{},{},{},{},{}".format(round(self.master_clock,2), 
			round(self.next_arrival,2), round(self.queue[0].service_completion_time,2), len(self.queue), self.retransmission_list))
		# print("{} \t {} \t {} \t {} \t {}".format(self.master_clock, self.next_arrival, self.queue[0].service_completion_time, len(self.queue), self.retransmission_list))
		# self.output_string += "{},{},{},{},{}".format(self.master_clock, self.next_arrival, self.queue[0].service_completion_time, len(self.queue), str(self.retransmission_list)) + "\n"
		
	# Prints Event List
	def print_event_list(self, event_list):
		for event in event_list:
			print(event.time)

	# Generating random exponential inter-arrival time (Poisson arrivals)
	def generate_exponential(self, arrival_rate):
		return numpy.random.exponential(arrival_rate)

	def pseudo_random(self):
		return random.random()

	# Function to generate exponentially spaced arrivals
	# arrival_rate == lambda
	# mean_iat == 1/lambda
	def nextTime(self, mean_iat):
		temp = -math.log(1.0 - random.random()) * mean_iat
		return temp
		# return float("{0:.2f}".format(temp))
		# return round(Decimal(temp), 2)

	def clear_all(self):
		self.queue = []
		self.retransmission_list = []
		self.master_clock = 0
		self.event_list = []
		self.devices_processed = []
		self.first_arrival = 0
		self.next_arrival = 0

# 'L' is list of values for which percentile 'p' supposed to be calculated
def calc_percentile(l, p):
	if not l: return 0
	l_sort = sorted(l)
	return l_sort[int(math.ceil(p * len(l)/100) - 1)]

def mean(l):
	if not l:	return 0
	return sum(l)/len(l)

def std_dev(l):
	# return np.std(l)
	if not l: return 0
	mean_val = mean(l)
	std_dev = math.sqrt(sum([(val - mean_val)**2 for val in l]) / len(l))
	return std_dev

def conf_int(l, n):
	if not l: return 0
	error = 1.96 * std_dev(l) / math.sqrt(n)
	mean_l = mean(l)
	return [mean_l - error, mean_l + error]

outfile = "output.csv"
statfile = "stat.csv"

def out_stat(s):
	# Opening file to write statistics
	with open(statfile, 'w', newline = '') as tempfile:
		writer = csv.writer(tempfile)
		writer.writerow(("System Arrival Time", "Queue AT", "Service Start Time", "Service Completion Time", "Retransmission Times",\
						 "Total Time in System", "Time Taken to Enter Q"))

	# Writing statistics, going through list of devices
	with open(statfile, 'a', newline = '') as csvfile:
		writer = csv.writer(csvfile)
		list_devices = list(s.devices_processed)
		for device in list_devices:
			writer.writerow((device.system_arrival_time, device.queue_arrival_time, device.service_start_time, device.service_completion_time, device.retransmission_times, \
							device.service_completion_time - device.system_arrival_time, device.queue_arrival_time - device.system_arrival_time))
'''
def out_table(s):
	# Opening file to write

	# Writing to the file, while simulating
	with open(outfile, 'a', newline='') as csvfile:
		writer = csv.writer(csvfile)
		random.seed(s.random_seed)
		s.first_arrival = s.nextTime(s.mean_inter_arrival_time)
		writer.writerow((s.master_clock, format(s.first_arrival, '.2f'), "-", "0", "[]"))
		while s.master_clock <= s.master_clock_limit:
			if(len(s.devices_processed) == s.input_devices):
				break
			s.simulate()
			# x = s.print_op()
			writer.writerow((format(s.master_clock, '.2f'), format(s.next_arrival, '.2f'), \
							format(s.queue[0].service_completion_time, '.2f') if s.queue else '-', len(s.queue), \
							s.retransmission_list))
							# [format(val, '.2f') for val in s.retransmission_list]))
		#s.print_event_list(s.event_list)
'''


# with open(outfile, 'wb') as tempfile:
# 	writer = csv.writer(tempfile)
# 	writer.writerow(('MC', 'CLA', 'CLS', 'Q', 'CLR'))



text_out = "temp.txt"
tout = open(text_out, 'wb')
# __main__ Function
for z in range(1,35+1):
	# Opening file to write
	final_out = "out_b" + str(z) + ".csv"
	# with open(final_out, 'wb') as tempfile:
	# 	writer = csv.writer(tempfile)
	# 	writer.writerow(('Repetition', 'Mean T', '95th Perc of T', 'Mean D', '95th Perc of D', 'P - Total Time to Process 1000 Devices'))

	array_t_95 = []
	array_d_95 = []
	array_t_mean = []
	array_d_mean = []
	array_p = []
	#with open(final_out, 'ab') as csvfile: #, open(outfile, 'ab') as csvfile2:
	with open(text_out, 'ab') as tout:
		#writer = csv.writer(csvfile)
		s = Simulation()
		s.buffer_size = int(z)
		for i in range(1,s.number_of_repetitions+1):
			s.random_seed = i
			random.seed(i)
			s.first_arrival = s.nextTime(s.mean_inter_arrival_time)
			s.next_arrival = s.first_arrival
			# print("Iteration #{}".format(i))

			# writer2 = csv.writer(csvfile2)
			# s.first_arrival = s.nextTime(s.mean_inter_arrival_time)
			# writer2.writerow((s.master_clock, s.first_arrival, "-", "0", "[]"))
			while s.master_clock <= s.master_clock_limit:
				if(len(s.devices_processed) == s.input_devices):
					break
				s.simulate()
				# writer2.writerow((format(s.master_clock, '.2f'), format(s.next_arrival, '.2f'), \
				# 				format(s.queue[0].service_completion_time, '.2f') if s.queue else '-', len(s.queue), \
				# 				s.retransmission_list))
				# writer2.writerow((s.master_clock, s.next_arrival, s.queue[0].service_completion_time if s.queue else '-', len(s.queue), s.retransmission_list))

			array_t = []
			array_d = []

			list_devices = list(s.devices_processed)
			for device in list_devices:
				array_t.append(device.service_completion_time - device.system_arrival_time)
				if len(device.retransmission_times) > 0:
					array_d.append(device.queue_arrival_time - device.system_arrival_time)

			# out_stat(s)

			t_mean = mean(array_t)
			t_95 = calc_percentile(array_t, 95)
			d_mean = mean(array_d)
			d_95 = calc_percentile(array_d, 95)

			# writer.writerow((i, t_mean, t_95, d_mean, d_95, s.master_clock))

			array_t_mean.append(t_mean)
			array_t_95.append(t_95)
			array_d_mean.append(d_mean)
			array_d_95.append(d_95)
			array_p.append(s.master_clock)

			# print("T 95% : " + str(calc_percentile(array_t, 95)))
			# print("D 95% : " + str(calc_percentile(array_d, 95)))
			# print("Mean T : " + str(mean(array_t)))
			# print("Mean D : " + str(mean(array_d)))
			# print("Total Time Taken : " + str(s.master_clock))
			# print("#Devices Processed : " + str(len(s.devices_processed)))

			s.clear_all()

		# T, the total amount of time it takes for a request to be processed from the moment it arrives to the queue to the moment it departs from the server
		# writer.writerow("\n")
		# writer.writerow(("Readings for Service Time : ", str(s.service_time)))
		# writer.writerow(("Reading for Buffer Size : ", str(s.buffer_size)))
		# writer.writerow(("Grand Mean T : ", str(mean(array_t_mean))))
		# writer.writerow(("CI Mean T : ", str(conf_int(array_t_mean, s.number_of_repetitions))))
		# # writer.writerow(("Grand 95%  T : ", str(calc_percentile(array_t_mean, 95))))
		# writer.writerow(("Grand Mean of 95%  T : ", str(mean(array_t_95))))
		# writer.writerow(("CI of Mean 95%  T : ", str(conf_int(array_t_95, s.number_of_repetitions))))
		# # print("Grand Mean T : " + str(mean(array_t_mean)))
		# # print("Grand 95%  T : " + str(calc_percentile(array_t_mean, 95)))
		# # print("Error T : " + str(std_dev(array_t_mean)))
		# # print("Conf Intl T : " + str(conf_int(array_t_mean, s.number_of_repetitions)))

		# # D, the amount of time elapsing from the moment a request is rejected to the moment it enters successfully the buffer
		# writer.writerow(("Grand Mean D : ", str(mean(array_d_mean))))
		# writer.writerow(("CI D : ", str(conf_int(array_d_mean, s.number_of_repetitions))))
		# # writer.writerow(("Grand 95%  D : ", str(calc_percentile(array_d_mean, 95))))
		# writer.writerow(("Grand Mean of 95%  D : ", str(mean(array_d_95))))
		# writer.writerow(("CI of Mean 95%  D : ", str(conf_int(array_d_95, s.number_of_repetitions))))
		# print("Grand Mean D : " + str(mean(array_d_mean)))
		# print("Grand 95%  D : " + str(calc_percentile(array_d_mean, 95)))
		# print("Error D : " + str(std_dev(array_d_mean)))
		# print("Conf Intl D : " + str(conf_int(array_d_mean, s.number_of_repetitions)))

		# P, the total time to process all 1,000 IoT devices
		# writer.writerow(("Mean P : ", str(mean(array_p))))
		# writer.writerow(("CI P : ", str(conf_int(array_p, s.number_of_repetitions))))
		# print("Avg Time to Process 1000 Devices P : " + str(mean(array_p)))
		# print("Conf Intl P : " + str(conf_int(array_p, s.number_of_repetitions)))

		tout.write(str(mean(array_d_mean)) + "\t\n")

'''
Output code
# print("Simulation started")
# print("First arrival at " + str(s.first_arrival))
# print("{} \t {} \t {} \t {} \t {}".format(s.master_clock, s.first_arrival, "-", "0", "[]"))

# out_str = ""
# out_str += "{},{},{},{},{}".format(s.master_clock, s.first_arrival, "-", "0", "[]")
'''
'''
def generate_arrivals():
	clock = first_arrival
	arrivals = []
	while(clock < master_clock_limit):
		arrivals.append(clock)
		clock += inter_arrival_time
	return arrivals

for a in arrival_queue:
	master_clock = a
	ar = Event()
	event_list.append(ar)
'''