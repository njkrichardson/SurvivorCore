"""Test vector generation script. Vectors are written to the 
`VECTORS_DIRECTORY` with pathname of the module under test. 

Usage: 
    python3 generate_vectors.py 
"""
from itertools import product
from pathlib import Path

import typer 

from utils import VECTORS_DIRECTORY

def generate_all_input_combinations(width):
    return list(product([0, 1], repeat=width))

def generate_tristate_buffer_test_vectors(width):
    input_combinations = generate_all_input_combinations(width)
    test_vectors = []

    for a in input_combinations:
        for en in [0, 1]:
            if en == 0:
                y = ['z'] * width
            else:
                y = a
            test_vectors.append((list(a), en, y))

    return test_vectors

def save_test_vectors_to_file(module_name, test_vectors):
    filename: Path = VECTORS_DIRECTORY / f"{module_name}{len(test_vectors[0][0])}.tv"
    with open(filename, 'w') as file:
        for a, en, y in test_vectors:
            file.write(''.join(str(bit) for bit in a) + str(en) + ''.join(str(bit) for bit in y) + '\n')
    print(f"Test vectors saved to {filename}")

def main():
    width: int = 3  # Change this to the desired width of the buffer

    # tristate buffer 
    test_vectors = generate_tristate_buffer_test_vectors(width)
    module_name = "tristate_buffer"
    save_test_vectors_to_file(module_name, test_vectors)

if __name__=="__main__": 
    typer.run(main)
