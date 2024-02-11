/* Core sequential logic elements 
*/ 

module flop #(parameter num_bits) 
    (
    input logic clock, 
    input logic [num_bits-1:0] data, 
    output logic [num_bits-1:0] state
    );
    always_ff @(posedge clock) 
        state <= data; 
endmodule 

module resettable_flop #(parameter num_bits) 
    (
    input logic clock, 
    input logic reset, 
    input logic [num_bits-1:0] data, 
    output logic [num_bits-1:0] state
    );
    always_ff @(posedge clock) 
        if (reset) state <= {num_bits{1'b0}}; 
        else state <= data; 
endmodule 

module resettable_flop_enabled #(parameter num_bits) 
    (
    input logic clock, 
    input logic reset, 
    input logic enabled, 
    input logic [num_bits-1:0] data, 
    output logic [num_bits-1:0] state
    );
    always_ff @(posedge clock) 
        if (reset) state <= {num_bits{1'b0}}; 
        else if (enabled) state <= data; 
endmodule 

module resettable_flop_async #(parameter num_bits) 
    (
    input logic clock, 
    input logic reset, 
    input logic [num_bits-1:0] data, 
    output logic [num_bits-1:0] state
    );
    always_ff @(posedge clock, posedge reset) 
        if (reset) state <= {num_bits{1'b0}}; 
        else state <= data; 
endmodule 

module register_file(
    input logic clock, reset, 
    input logic write_enable, 
    input logic [3:0] address1, address2, address3, 
    input logic [31:0] write_data, program_counter, 
    output logic [31:0] read1, read2
    ); 
endmodule 
