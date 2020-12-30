"""
@author: Frank

generates incrementing entries memory file.
command line arguments: bit width(12), bit depth(16)

"""

import sys
import numpy as np

if len(sys.argv) != 3:
    print("Incorrect number of arguments. Expected input: 'python inc_gen.py width depth")
    exit()

width = 2**int(sys.argv[1])
depth = 2**int(sys.argv[2])

memory_file_path = "./mem/inc_w{0}_d{1}.coe".format(sys.argv[1], sys.argv[2])
memory_file = open(memory_file_path, "w")

for x in range(depth):
    data_point = int(x % width)
    memory_file.write("{:02x} ".format(data_point))

