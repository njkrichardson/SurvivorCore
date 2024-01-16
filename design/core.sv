/* Basic combinational modules. 
 - Tristate buffers
 - Multiplexers 

*/ 

module inverter(
	input logic [3:0] a, 
	output logic [3:0] y, 
	); 
	assign y = ~a; 
endmodule

module tristate_buffer(
	input logic [3:0] a, 
    input logic en, 
    output tri [3:0] y
	); 
    assign y = en ? a : 4'bz; 
endmodule 
