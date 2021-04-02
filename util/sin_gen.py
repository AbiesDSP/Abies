import sys
import numpy as np
import binascii

# Sketchy code copied from stack overflow.
def twos_comp(val, nbits):
    """compute the 2's complement of int value val"""
    if (val & (1 << (nbits - 1))) != 0: # if sign bit is set e.g., 8bit: 128-255
        val = val - (1 << nbits)        # compute negative value
    return val & ((2 ** nbits) - 1)

def tohex(val, nbits):
    hexval = hex(twos_comp(val, nbits))
    return hexval[2:]

if __name__ == '__main__':
    if len(sys.argv) != 4:
        print("Incorrect number of arguments. Expected input: 'python sin_gen.py width depth type(1, 2, 4)")
        exit()

    width = 2**int(sys.argv[1])
    depth = 2**int(sys.argv[2])
    div = int(sys.argv[3])

    memory_file_path = "./mem/sin_w{0}_d{1}.mem".format(sys.argv[1], sys.argv[2])
    memory_file = open(memory_file_path, "w")

    maxval = 2**(int(sys.argv[1])-1)-1
    for x in range(depth):
        # https://zipcpu.com/dsp/2017/08/26/quarterwave.html
        # To get a lower-distortion sin wave when using a half or quarter wave table,
        # add a half sample of phase to the table entries.
        ph = (2.0 * np.pi * x) / (depth * div)
        # ph += np.pi / (depth * div)
        data_point = int(maxval * np.sin(ph))
        # data_point = int(((width-1)/2)*np.sin((2*np.pi*(2*x + 1))/(2 * depth*div)))
        hexval = tohex(data_point, int(sys.argv[1]))
        memory_file.write(f"{hexval} ")

