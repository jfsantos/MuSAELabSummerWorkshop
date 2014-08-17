from sklearn import datasets
from cPickle import dump

digits = datasets.load_digits()
dump(digits, open('digits.pkl', 'w'))
