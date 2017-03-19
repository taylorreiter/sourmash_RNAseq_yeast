import json
from glob import glob
import os


if __name__ == "__main__":
    for original in glob('*.sig'):
        with open(original, 'r') as f:
            fc = 0
            current_sig = []
            for line in f:
                if line == "][\n":
                    current_sig += ']\n'
                    with open("{}.{}.fixed".format(original, fc), 'w') as output:
                        output.write("".join(current_sig))
                    fc += 1
                    current_sig = ['[\n']
                else:
                    current_sig += line
            with open("{}.{}.fixed".format(original, fc), 'w') as output:
                output.write("".join(current_sig))
                