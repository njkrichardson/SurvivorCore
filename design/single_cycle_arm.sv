/* Single cycle processor implementing a subset of the Armv4 architecture. 
* 
*/

module arm(
    input logic clock, reset, 
    input logic [31:0] instruction, 
    input logic [31:0] read_data, 
    output logic write_memory, 
    output logic [31:0] program_counter, 
    output logic [31:0] ALU_result, write_data
    ); 
    /*
    * Single cycle Armv4 processor. 
    *
    * At the highest level, the core is comprised of a datapath and a controller. 
    * The datapath executes operations, modulated according to control signals 
    * (e.g., mux selects, ALU controls) generated in the controller. 
    */

    // controller signals
    logic write_register, ALU_source, memory_to_register, pc_source; 
    logic [1:0] register_source, immediate_source, ALU_control; 

    // datapath telemetry 
    logic [3:0] ALU_flags; 

    // modules 
    controller c(
        // inputs 
        clock, 
        reset, 
        instruction[31:12], 
        ALU_flags, 
        // ouputs 
        register_source, 
        immediate_source, 
        ALU_control, 
        ALU_source, 
        pc_source, 
        memory_to_register, 
        write_register, 
        write_memory
        ); 

    datapath d(
        // inputs 
        clock, 
        reset, 
        register_source, 
        write_register, 
        immediate_source, 
        ALU_control, 
        ALU_source, 
        pc_source, 
        memory_to_register, 
        read_data, 
        instruction, 
        // outputs
        ALU_flags, 
        program_counter, 
        ALU_result, 
        write_data
        ); 

endmodule 
