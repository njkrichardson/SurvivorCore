/* Basic combinational modules. 
 - Tristate buffers
 - Multiplexers 

*/ 

module inverter #(parameter num_bits=8)
    (
	input logic [num_bits-1:0] a, 
	output logic [num_bits-1:0] y
	); 
	assign y = ~a; 
endmodule

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
    input logic [23:0] value, 
    input logic [1:0] control, 
    output logic [31:0] result
    ); 

endmodule 

