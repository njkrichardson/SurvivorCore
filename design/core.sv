/* Basic combinational modules. 
 - Tristate buffers
 - Multiplexers 

*/ 

module tristate_buffer #(parameter num_bits)
    (
	input logic [num_bits-1:0] a, 
    input logic en, 
    output tri [num_bits-1:0] y
	); 
    assign y = en ? a : {num_bits{1'bz}}; 
endmodule 

module adder #(parameter num_bits)
    (
    input logic [num_bits-1:0] a, b, 
    output logic [num_bits-1:0] sum
    ); 
    assign sum = a + b; 
endmodule

module adder_carryout #(parameter num_bits)
    (
    input logic [num_bits-1:0] a, b, 
    output logic carry_out, 
    output logic [num_bits-1:0] sum
    ); 
    assign {sum, carry_out} = a + b; 
endmodule

module mux2 #(parameter num_bits) 
    (
    input logic [num_bits-1:0] a, b, 
    input logic select, 
    output logic [num_bits-1:0] y
    ); 
    assign y = select ? b : a; 
endmodule 

module mux4 #(parameter num_bits) 
    (
    input logic [num_bits-1:0] a, b, c, d, 
    input logic [1:0] select, 
    output logic [num_bits-1:0] y
    ); 
    logic [num_bits-1:0] low_result, high_result; 

    mux2 #(num_bits) low_mux(a, b, select[0], low_result); 
    mux2 #(num_bits) high_mux(c, d, select[0], high_result); 
    mux2 #(num_bits) resut_mux(low_result, high_result, select[1], y); 
endmodule 

module decoder #(parameter num_bits)
    (
    input logic [num_bits-1:0] a, 
    output logic [2**num_bits-1:0] y
    ); 
    always_comb 
        begin 
            y = 0; 
            y[a] = 1; 
        end
endmodule

module extender(
    input logic [23:0] immediate, 
    input logic [1:0] immediate_source, 
    output logic [31:0] result
    ); 
    always_comb 
        case(immediate_source)
            2b'00:  result = {24b'0, immediate[7:0]}; // 8-bit unsigned immediate 
            2b'01:  result = {20'b0, immediate[11:0]}; // 12-bit unsigned immediate 
            2b'10:  result = {{6{immediate[23}}, immediate[23:0], 2'b00}; 
            default: result = 32'bx; 
    endcase 
endmodule 
