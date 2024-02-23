/* Basic ALU implementation with status flags for the Arm architecture 
*/
module alu(
    input logic [31:0] source_a, source_b, 
    input logic [1:0] control, 
    output logic [31:0] result, 
    output logic [3:0] flags // {N, Z, C, V} 
    ); 
    logic n, z, c, v; 
    logic carry_out; 

    always_comb
        case(control) 
            2'b00 : {carry_out, result} = source_a + source_b; // add 
            2'b01 : result = source_a - source_b; // sub 
            2'b10 : result = source_a & source_b; // bitwise and 
            2'b11 : result = source_a | source_b; // bitwise or 
        endcase 

    assign n = result[31]; 
    assign z = (result == 32'b0); 
    assign c = (~control[1]) & (carry_out); 
    assign v = (~(control[0] ^ source_a[31] ^ source_b[31]) & (source_a[31] ^ result[31]) & (~control[1])); 
    assign flags = {n, z, c, v}; 

endmodule
