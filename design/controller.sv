/* Single-cycle Armv4 controller. 
*/
module controller(
        input logic clock, reset, 
        input logic [18:0] instruction, 
        input logic [3:0] ALU_flags, 
        output logic [1:0] register_source, 
            immediate_source, 
            ALU_control, 
        output logic ALU_source, 
            pc_source, 
            memory_to_register, 
            write_register, 
            write_memory
        ); 
        /* Single cycle datapath controller, comprised of a 
        * decoder and conditional logic. 
        */
        logic _write_flag, 
            _pc_source, 
            _write_register, 
            _write_memory, 


        instruction_decoder d(
            /*operation=*/instruction[27:26], 
            /*function=*/instruction[25:20], 
            /*destination=*/instruction[15:12], 
            _write_flag, 
            _pc_source, 
            _write_regiser, 
            _write_memory, 
            memory_to_register
            ALU_source, 
            immediate_source, 
            register_source, 
            ALU_control
            ); 
        conditional_logic cl(
            /*condition=*/instruction[31:28], 
            ALU_flags, 
            _write_flag, 
            _write_register, 
            _write_memory, 
            pc_source, 
            write_register, 
            write_memory
            ); 
endmodule

module conditional_logic(
    input logic [3:0] condition, 
    input logic [3:0] ALU_flags, 
    input logic [1:0] _write_flag, 
    input logic _pc_source, 
        _write_register, 
        _write_memory, 
    output logic pc_source, 
        write_register, 
        write_memory
    ); 

endmodule
