import sys
import collections
import sklearn.naive_bayes
import sklearn.linear_model
import nltk
import random
random.seed(0)
from gensim.models.doc2vec import LabeledSentence, Doc2Vec
from collections import Counter
import warnings
# nltk.download("stopwords")          # Download the stop words from nltk
# Removing DeprecationWarning from output while executing the code
warnings.filterwarnings("ignore", category=DeprecationWarning)


# User input path to the train-pos.txt, train-neg.txt, test-pos.txt, and test-neg.txt datasets
if len(sys.argv) != 3:
    print("python sentiment.py <path_to_data> <0|1>")
    print("0 = NLP, 1 = Doc2Vec")
    exit(1)
path_to_data = sys.argv[1]
method = int(sys.argv[2])


def main():
    train_pos, train_neg, test_pos, test_neg = load_data(path_to_data)

    if method == 0:
        train_pos_vec, train_neg_vec, test_pos_vec, test_neg_vec = feature_vecs_NLP(train_pos, train_neg, test_pos, test_neg)
        nb_model, lr_model = build_models_NLP(train_pos_vec, train_neg_vec)
    if method == 1:
        train_pos_vec, train_neg_vec, test_pos_vec, test_neg_vec = feature_vecs_DOC(train_pos, train_neg, test_pos, test_neg)
        nb_model, lr_model = build_models_DOC(train_pos_vec, train_neg_vec)
    print("Naive Bayes")
    print("-----------")
    evaluate_model(nb_model, test_pos_vec, test_neg_vec, True)
    print("")
    print("Logistic Regression")
    print("-------------------")
    evaluate_model(lr_model, test_pos_vec, test_neg_vec, True)


def load_data(path_to_dir):
    """
    Loads the train and test set into four different lists.
    """
    train_pos = []
    train_neg = []
    test_pos = []
    test_neg = []
    with open(path_to_dir + "train-pos.txt", "r") as f:
        for line in f:
            words = [w.lower() for w in line.strip().split() if len(w) >= 3]
            train_pos.append(words)
    with open(path_to_dir + "train-neg.txt", "r") as f:
        for line in f:
            words = [w.lower() for w in line.strip().split() if len(w) >= 3]
            train_neg.append(words)
    with open(path_to_dir + "test-pos.txt", "r") as f:
        for line in f:
            words = [w.lower() for w in line.strip().split() if len(w) >= 3]
            test_pos.append(words)
    with open(path_to_dir + "test-neg.txt", "r") as f:
        for line in f:
            words = [w.lower() for w in line.strip().split() if len(w) >= 3]
            test_neg.append(words)

    return train_pos, train_neg, test_pos, test_neg


def feature_vecs_NLP(train_pos, train_neg, test_pos, test_neg):
    """
    Returns the feature vectors for all text in the train and test datasets.
    """
    # English stopwords from nltk
    stopwords = set(nltk.corpus.stopwords.words('english'))

    # Determine a list of words that will be used as features.
    # This list should have the following properties:
    #   (1) Contains no stop words
    #   (2) Is in at least 1% of the positive texts or 1% of the negative texts
    #   (3) Is in at least twice as many postive texts as negative texts, or vice-versa.
    # YOUR CODE HERE

    # Parse over the pos-neg data given; remove if it is a stopword; create a dictionary; check for 1% of overall pos/neg; twice pos-neg; return lists

    # Creating a list of words and Removing Stop words
    list_of_pos_words = [word for sublist in train_pos for word in set(sublist) if word not in stopwords]
    list_of_neg_words = [word for sublist in train_neg for word in set(sublist) if word not in stopwords]
    # list_of_pos_words = list(train_pos.split(" "))
    # list_of_neg_words = list(train_neg.split(" "))

    # Getting a word count
    count_of_pos_words = Counter(list_of_pos_words)
    count_of_neg_words = Counter(list_of_neg_words)
    all_words = set(list(count_of_pos_words) + list(count_of_neg_words))

    # Creating an empty list of words to append to
    list_of_words = []
    # If word is in at least 1% of positive texts or 1% of negative texts
    posthreshold = 0.01 * len(train_pos)
    negthreshold = 0.01 * len(train_neg)
    list_of_words = [word for word in all_words if count_of_pos_words[word] >= posthreshold or count_of_neg_words[word] >= negthreshold]
    '''
    for word in list(count_of_pos_words):
        if(count_of_pos_words[word] >= 0.01 * len(count_of_pos_words)):
            list_of_words.append(word)
    for word in list(count_of_neg_words):
        if(count_of_neg_words[word] >= 0.01 * len(count_of_neg_words)):
            list_of_words.append(word)
    '''

    # If word is in at least twice as many positive or negative texts
    list_of_words = [word for word in list_of_words if count_of_pos_words[word] >= 2 * count_of_neg_words[word] or count_of_neg_words[word] >= 2 * count_of_pos_words[word]]
    '''
    for word in list(count_of_pos_words):
        if(count_of_pos_words[word] >= 2 * count_of_neg_words[word]):
            list_of_words.append(word)
    for word in list(count_of_neg_words):
        if(count_of_neg_words[word] >= 2 * count_of_pos_words[word]):
            list_of_words.append(word)
    '''

    # Using the above words as features, construct binary vectors for each text in the training and test set.
    # These should be python lists containing 0 and 1 integers.
    # YOUR CODE HERE

    def getFeatureVector(data, featurelist):
        list_of_feature_vecs = []
        for line in data:
            featurevector = [0] * len(featurelist)
            for word in line:
                if word in featurelist:
                    featurevector[featurelist.index(word)] = 1
            list_of_feature_vecs.append(featurevector)
        return list_of_feature_vecs

    train_pos_vec = getFeatureVector(train_pos, list_of_words)
    train_neg_vec = getFeatureVector(train_neg, list_of_words)
    test_pos_vec = getFeatureVector(test_pos, list_of_words)
    test_neg_vec = getFeatureVector(test_neg, list_of_words)

    # Return the four feature vectors
    return train_pos_vec, train_neg_vec, test_pos_vec, test_neg_vec


def feature_vecs_DOC(train_pos, train_neg, test_pos, test_neg):
    """
    Returns the feature vectors for all text in the train and test datasets.
    """
    # Doc2Vec requires LabeledSentence objects as input.
    # Turn the datasets from lists of words to lists of LabeledSentence objects.
    # YOUR CODE HERE
    def getLabeledSentence(dataset, labeltype):
        listls = []
        for i, line in enumerate(dataset):
            label = '%s_%s' % (labeltype, i)
            listls.append(LabeledSentence(line, [label]))
        return listls

    labeled_train_pos = getLabeledSentence(train_pos, 'train_pos')
    labeled_train_neg = getLabeledSentence(train_neg, 'train_neg')
    labeled_test_pos = getLabeledSentence(test_pos, 'test_pos')
    labeled_test_neg = getLabeledSentence(test_neg, 'test_neg')

    # Initialize model
    model = Doc2Vec(min_count=1, window=10, size=100, sample=1e-4, negative=5, workers=4)
    sentences = labeled_train_pos + labeled_train_neg + labeled_test_pos + labeled_test_neg
    model.build_vocab(sentences)

    # Train the model
    # This may take a bit to run
    for i in range(5):
        print("Training iteration %d" % (i))
        random.shuffle(sentences)
        model.train(sentences)

    # Use the docvecs function to extract the feature vectors for the training and test data
    # YOUR CODE HERE
    def getVecs(model, dataset, labeltype):
        fv = []
        for i, line in enumerate(dataset):
            label = '%s_%s' % (labeltype, i)
            fv.append(model.docvecs[label])
        return fv

    train_pos_vec = getVecs(model, train_pos, 'train_pos')
    train_neg_vec = getVecs(model, train_neg, 'train_neg')
    test_pos_vec = getVecs(model, test_pos, 'test_pos')
    test_neg_vec = getVecs(model, test_neg, 'test_neg')

    '''
    def getVecs(model, corpus, size):
        vecs = [np.array(model[z.labels[0]]).reshape((1, size)) for z in corpus]
        return np.concatenate(vecs)
    
    size = 100
    
    def getFV(model, dataset, size):
        vec_dm = getVecs(model, ds, size)
        vec_dbow = getVecs(model, ds, size)
        fv = np.hstack((vec_dm, vec_dbow))
        return fv
    
    train_pos_vec = getFV(model, labeled_train_pos, size)
    train_neg_vec = getFV(model, labeled_train_neg, size)
    test_pos_vec = getFV(model, labeled_test_pos, size)
    test_neg_vec = getFV(model, labeled_test_neg, size)
    '''

    # Return the four feature vectors
    return train_pos_vec, train_neg_vec, test_pos_vec, test_neg_vec


def build_models_NLP(train_pos_vec, train_neg_vec):
    """
    Returns a BernoulliNB and LosticRegression Model that are fit to the training data.
    """
    X = train_pos_vec + train_neg_vec
    Y = ["pos"] * len(train_pos_vec) + ["neg"] * len(train_neg_vec)

    # Use sklearn's BernoulliNB and LogisticRegression functions to fit two models to the training data.
    # For BernoulliNB, use alpha=1.0 and binarize=None
    # For LogisticRegression, pass no parameters
    # YOUR CODE HERE

    nb = sklearn.naive_bayes.BernoulliNB(alpha=1.0, binarize=None)
    nb_model = nb.fit(X, Y)

    lr = sklearn.linear_model.LogisticRegression()
    lr_model = lr.fit(X, Y)

    return nb_model, lr_model


def build_models_DOC(train_pos_vec, train_neg_vec):
    """
    Returns a GaussianNB and LosticRegression Model that are fit to the training data.
    """
    X = train_pos_vec + train_neg_vec
    Y = ["pos"] * len(train_pos_vec) + ["neg"] * len(train_neg_vec)

    # Use sklearn's GaussianNB and LogisticRegression functions to fit two models to the training data.
    # For LogisticRegression, pass no parameters
    # YOUR CODE HERE

    nb = sklearn.naive_bayes.GaussianNB()
    nb_model = nb.fit(X, Y)

    lr = sklearn.linear_model.LogisticRegression()
    lr_model = lr.fit(X, Y)

    return nb_model, lr_model


def evaluate_model(model, test_pos_vec, test_neg_vec, print_confusion=False):
    """
    Prints the confusion matrix and accuracy of the model.
    """
    # Use the predict function and calculate the true/false positives and true/false negative.
    # YOUR CODE HERE

    tp = 0.0
    tn = 0.0
    fp = 0.0
    fn = 0.0
    for entry in test_pos_vec:
        if model.predict(entry) == ['pos']:
            tp += 1
        else:
            fn += 1
    for entry in test_neg_vec:
        if model.predict(entry) == ['neg']:
            tn += 1
        else:
            fp += 1
    accuracy = (tp + tn) / (tp + tn + fp + fn)

    if print_confusion:
        print("predicted:\tpos\tneg")
        print("actual:")
        print("pos\t\t%d\t%d" % (tp, fn))
        print("neg\t\t%d\t%d" % (fp, tn))
    print("accuracy: %f" % (accuracy))


if __name__ == "__main__":
    main()
