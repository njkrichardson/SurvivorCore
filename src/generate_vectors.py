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

def generate_tristate_buffer_test_vectors(num_bits):
    input_combinations = generate_all_input_combinations(num_bits)
    test_vectors = []

    for a in input_combinations:
        for en in [0, 1]:
            y = 'z' * num_bits if not en else ''.join(str(bit) for bit in a)
            test_vectors.append(tuple(a) + (en,) + (y,))

    return test_vectors

def generate_mux2_test_vectors(num_bits):
    input_combinations = generate_all_input_combinations(num_bits)
    test_vectors = []

    for a in input_combinations:
        for b in input_combinations:
            for select in [0, 1]:
                y = ''.join(str(bit) for bit in a) if select == 0 else ''.join(str(bit) for bit in b)
                test_vectors.append(tuple(a) + tuple(b) + (select,) + (y,))

    return test_vectors

def generate_decoder_test_vectors(num_bits): 
    input_combinations = generate_all_input_combinations(num_bits)
    test_vectors = []

    for a in input_combinations: 
        binary_string = ''.join(map(str, a))
        a_decimal = int(binary_string, 2)
        y = ['0'] * (2**num_bits)
        y[-(a_decimal + 1)] = '1'
        test_vectors.append(tuple(a) + (''.join(y),))

    return test_vectors

def save_test_vectors_to_file(module_name, num_bits, test_vectors):
    filename = VECTORS_DIRECTORY / f"{module_name}_{num_bits}b.tv"
    string_representation = ''.join(str(item) for item in test_vectors[0])
    vector_length = len(string_representation)
    with open(filename, 'w') as file:
        for i, vector in enumerate(test_vectors):
            file.write(''.join(str(bit) for bit in vector))
            if i < len(test_vectors) - 1:
                file.write('\n')
            else:
                file.write('\n')
                file.write('x' * vector_length)  

    print(f"Test vectors saved to {filename}")

def main():
    bit_width: int = 4

    # tristate buffer 
    test_vectors = generate_tristate_buffer_test_vectors(bit_width)
    module_name = "tristate_buffer"
    save_test_vectors_to_file(module_name, bit_width, test_vectors)

    # 2-way multiplexer
    test_vectors = generate_mux2_test_vectors(bit_width)
    module_name = "mux2"
    save_test_vectors_to_file(module_name, bit_width, test_vectors)

    # decoder
    test_vectors = generate_decoder_test_vectors(bit_width)
    module_name = "decoder"
    save_test_vectors_to_file(module_name, bit_width, test_vectors)

if __name__=="__main__": 
    typer.run(main)
