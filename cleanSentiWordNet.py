import pandas
import numpy as np

data = np.array(pandas.read_csv('Data/SentiWordNet_3.0.0_20130122-preprocessed.csv'))
finalList = []

for index, line in enumerate(data):
	word = line[0].split('#', 1)[0]
	posScore = line[1]
	negScore = line[2]
	finalList.append([word, posScore, negScore])
np.savetxt('Data/SentiNet-preprocessed.csv', finalList, delimiter=",")
