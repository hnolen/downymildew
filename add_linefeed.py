#! /usr/bin/env python3

## this adds a linefeed to sequencing files from Eurofins (.seq) in a directory so they can be concatenated
## into one file for use in phylogenetic pipeline... alignment, etc ...

import os
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('dir', type=str, help='path to directory with the seq files you want to work with')
args = parser.parse_args()

try:
    for file in os.scandir(args.dir):
        with open(file, 'a') as handle:
            handle.seek(0,2)
            handle.write('\n')
except IOError:
    print('Error writing file')
