import cPickle
from sklearn import svm
import numpy as np

def load_data(path, test_size, random_seed):
    np.random.seed(random_seed)
    digits = cPickle.load(open("digits.pkl"))
    X = digits.images.reshape((digits.images.shape[0], -1))
    y = digits.target

    idx = np.random.permutation(X.shape[0])
    n_train_samples = int(round(len(X)*(1-test_size)))
    
    X_train = X[idx[0:n_train_samples]]
    X_test = X[idx[n_train_samples:]]
    y_train = y[idx[0:n_train_samples]]
    y_test = y[idx[n_train_samples:]]
    return X_train, y_train, X_test, y_test

def train(X_train, y_train, C, loss):
    classifier = svm.LinearSVC(C=C, loss=loss)
    classifier.fit(X_train, y_train)
    return classifier

def test(classifier, X, y):
    y_hat = classifier.predict(X)
    acc = float(sum(y_hat == y))/len(y)
    return y_hat, acc

def run_experiment(random_seed, data, C, loss):
    np.random.seed(random_seed)
    X_train, y_train, X_test, y_test = data
    classifier = train(X_train, y_train, C, loss)
    y_hat, acc = test(classifier, X_test, y_test)
    return y_hat, acc
