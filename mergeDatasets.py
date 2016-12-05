import pandas
import numpy as np
import click
import os




def preproc_file(input_file, number):
	data = np.array(pandas.read_csv(input_file, delim_whitespace=True))
	# if number == 2:
	# 	for instance in np.array(data)[0]
	print data[0]


def main():
	data_1 = preproc_file('Data/AFINN-111-preprocessed.csv', 1)
	data_2 = preproc_file('Data/labmt-preproc.csv', 1)
	data_3 = preproc_file('Data/SentiWordNet_3.0.0_20130122-preprocessed.csv', 2)


if __name__ == '__main__':
	main()