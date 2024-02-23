/* 32-bit Arm single cycle processor and on-die memory system. 
*/
module processor(
    input logic clock, reset, 
    output logic [31:0] write_data, address, 
    output logic write_memory
    ); 
    // internal signals
    logic [31:0] program_counter, instruction, read_data; 

    // instantiate processor 
    arm arm(
        clock, 
        reset, 
        instruction, 
        read_data, 
        write_memory, 
        program_counter, 
        address, 
        write_data
        ); 

    // instantiate memories
    instruction_memory imem(program_counter, instruction); 
    data_memory dmem(clock, write_memory, address, write_data, read_data);  
endmodule
