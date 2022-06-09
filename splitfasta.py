#! /usr/bin/env python3
import sys

def redirect_to_file(text):
	original = sys.stdout
	sys.stdout = open('/mnt/lustre/davis/hbn1002/fastANI/',name, 'w')
	print(text)
	sys.stdout = original


user = input()
fasta_list = []

for line in user:
	fasta_list.append(line)    

count = 1
for item in range(0, len(fasta_list), 2):
	sequence = fasta_list[item:item+2]
	name = str(count) + 'fasta.fa'
	redirect_to_file(sequence)
	count += 1
	if item == '':
		break

