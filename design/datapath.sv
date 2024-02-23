/* Single-cycle Armv4 datapath. 
*/ 

module datapath(
    input logic clock, reset, 
    input logic [1:0] register_source, 
    input logic write_register, 
    input logic [1:0] immediate_source, ALU_control, 
    input logic ALU_source, 
        pc_source, 
        memory_to_register, 
    input logic [31:0] read_data, 
    input logic [31:0] instruction, 
    output logic [3:0] ALU_flags, 
    output logic [31:0] program_counter, 
    output logic [31:0] ALU_result, 
    output logic [31:0] write_data
    ); 
    // internal signals 
    logic [31:0] PC_plus_4, PC_plus_8, result, next_program_counter; 
    logic [31:0] ALU_source_a, ALU_source_b, extended_immediate; 
    logic [3:0] register_address1, register_address2; 

    // next program counter logic 
    mux2 #(32) pc_mux(PC_plus_4, result, pc_source, next_program_counter); 
    resettable_flop #(32) pc(clock, reset, next_program_counter, program_counter); 
    adder #(32) pc_add4(program_counter, 32'b100, PC_plus_4); 
    adder #(32) pc_add8(PC_plus_4, 32'b100, PC_plus_8); 
    
    // register file logic 
    register_file rf(
        clock, 
        reset, 
        write_register, 
        register_address1, register_address2, 
        /*A3=*/instruction[15:12], 
        result, 
        PC_plus_8, 
        ALU_source_a, 
        write_data
        ); 
    mux2 #(4) ra1_mux(instruction[19:16], 4'b1111, register_source[0], register_address1); 
    mux2 #(4) ra2_mux(instruction[3:0], instruction[15:12], register_source[1], register_address2); 
    mux2 #(32) result_mux(ALU_result, read_data, memory_to_register, result); 

    // Extension 
    extender ext(instruction[23:0], immediate_source, extended_immediate); 
    
    // ALU logic 
    mux2 #(32) sourceb_mux(write_data, extended_immediate, ALU_source, ALU_source_b); 
    alu _alu(ALU_source_a, ALU_source_b, ALU_control, ALU_result, ALU_flags); 

endmodule; 
