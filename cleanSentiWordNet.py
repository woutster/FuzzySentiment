# Clean the SentiWordNet dataset
# Unfortunately there are a lot of hastags after each word, so we can strip those and save the new file.

import pandas
import numpy as np

data = np.array(pandas.read_csv('Data/SentiWordNet_3.0.0_20130122-preprocessed.csv'))
finalList = []

for index, line in enumerate(data):
	word = line[0].split('#', 1)[0]
	posScore = line[1]
	negScore = line[2]
	finalList.append([word, posScore, negScore])
data = pandas.DataFrame.from_records(finalList)
data.to_csv('Data/SentiNet-preprocessed.csv', sep= ' ', columns=None, index=False)
