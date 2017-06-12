from pyspark import SparkConf, SparkContext
from pyspark.streaming import StreamingContext
from pyspark.streaming.kafka import KafkaUtils
import operator
import numpy as np
import matplotlib.pyplot as plt


def main():
    conf = SparkConf().setMaster("local[2]").setAppName("Streamer")
    sc = SparkContext(conf=conf)
    ssc = StreamingContext(sc, 10)   # Create a streaming context with batch interval of 10 sec
    ssc.checkpoint("checkpoint")

    pwords = load_wordlist("positive.txt")
    nwords = load_wordlist("negative.txt")
   
    counts = stream(ssc, pwords, nwords, 100)
    # print(counts)
    make_plot(counts)


def make_plot(counts):
    """
    Plot the counts for the positive and negative words for each timestep.
    Use plt.show() so that the plot will popup.
    """
    # YOUR CODE HERE
    positive = []
    negative = []
    for entry in counts:
        if entry==[]:
            continue
        else:
            positive.append(entry[0][1])
            negative.append(entry[1][1])
    xdata = list(xrange(len(positive)))
    plt.xticks(xdata)
    pplot = plt.plot(positive, '-bo', label='positive')
    nplot = plt.plot(negative, '-ro', label='negative')
    plt.xlabel('Time Step')
    plt.ylabel('Word Count')
    plt.ylim(ymin=0, ymax=max(max(positive), max(negative))+50)
    plt.legend(['positive', 'negative'], loc=2)
    plt.show()



def load_wordlist(filename):
    """ 
    This function should return a list or set of words from the given filename.
    """
    # YOUR CODE HERE
    wordlist=[]
    with open(filename, 'r') as f:
        for line in f:
            if line!="":
                wordlist.append(line[:-1])
    return wordlist


def stream(ssc, pwords, nwords, duration):
    kstream = KafkaUtils.createDirectStream(
        ssc, topics = ['twitterstream'], kafkaParams = {"metadata.broker.list": 'localhost:9092'})
    tweets = kstream.map(lambda x: x[1].encode("ascii","ignore"))

    # Each element of tweets will be the text of a tweet.
    # You need to find the count of all the positive and negative words in these tweets.
    # Keep track of a running total counts and print this at every time step (use the pprint function).
    # YOUR CODE HERE
    tweets.pprint()

    def posorneg(word):
        if word in pwords:
            return ('positive', 1)
        elif word in nwords:
            return ('negative', 1)
        else:
            return ('neutral', 1)

    words = tweets.flatMap(lambda line: line.split(" "))
    wordsLabelled = words.map(posorneg).filter(lambda b: (b[0]=='positive' or b[0]=='negative'))
    wordCounts = wordsLabelled.reduceByKey(lambda x,y: x+y)
    # wordCounts.pprint()

    def updateFunction(newValues, runningCount):
        if runningCount is None:
            runningCount = 0
        return sum(newValues, runningCount)

    runningCounts = wordsLabelled.updateStateByKey(updateFunction)
    runningCounts.pprint()
    
    
    # Let the counts variable hold the word counts for all time steps
    # You will need to use the foreachRDD function.
    # For our implementation, counts looked like:
    #   [[("positive", 100), ("negative", 50)], [("positive", 80), ("negative", 60)], ...]
    counts = []
    wordCounts.foreachRDD(lambda t,rdd: counts.append(rdd.collect()))
    
    ssc.start()                         # Start the computation
    ssc.awaitTerminationOrTimeout(duration)
    ssc.stop(stopGraceFully=True)

    return counts


if __name__=="__main__":
    main()
