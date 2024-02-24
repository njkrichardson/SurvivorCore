/* Single-cycle Armv4 controller. 
*/
module controller(
        input logic clock, reset, 
        input logic [31:12] instruction, 
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
        logic _pc_source, 
            _write_register, 
            _write_memory; 
        logic [1:0] _write_flag; 

        instruction_decoder d(
            /*operation=*/instruction[27:26], 
            /*function=*/instruction[25:20], 
            /*destination=*/instruction[15:12], 
            _write_flag, 
            _pc_source, 
            _write_register, 
            _write_memory, 
            memory_to_register, 
            ALU_source, 
            immediate_source, 
            register_source, 
            ALU_control
            ); 
        conditional_logic cl(
            clock, 
            reset, 
            /*condition=*/instruction[31:28], 
            ALU_flags, 
            _write_flag, 
            _pc_source, 
            _write_register, 
            _write_memory, 
            pc_source, 
            write_register, 
            write_memory
            ); 
endmodule

module conditional_logic(
    input logic clock, reset, 
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
    // internal signals 
    logic [1:0] write_flag; 
    logic [3:0] flags; 
    logic conditionally_execute; 

    // internal state 
    resettable_flop_enabled #(2) flags_register0(clock, reset, write_flag[1], ALU_flags[3:2], flags[3:2]); 
    resettable_flop_enabled #(2) flags_register1(clock, reset, write_flag[0], ALU_flags[1:0], flags[1:0]); 

    // parse the condition field 
    condition_parser _condition_parser(flags, condition, conditionally_execute); 

    // gate conditional execution 
    assign pc_source = _pc_source & conditionally_execute; 
    assign write_register = _write_register & conditionally_execute; 
    assign write_memory = _write_memory & conditionally_execute; 
    assign write_flag = _write_flag & {2{conditionally_execute}}; 
endmodule

module condition_parser(
    input logic [3:0] flags, 
    input logic [3:0] condition, 
    output logic conditionally_execute
    );
    // unpack the flags 
    logic n, z, c, v; 
    assign {n, z, c, v} = flags; 

    always_comb 
        case(condition)
            4'b0000: conditionally_execute = z;             // Equal 
            4'b0001: conditionally_execute = ~z;            // Not equal 
            4'b0010: conditionally_execute = c;             // Unsigned greater-than or equal-to 
            4'b0011: conditionally_execute = ~c;            // Unsigned less than 
            4'b0100: conditionally_execute = n;             // Negative
            4'b0101: conditionally_execute = ~n;            // Non-negative 
            4'b0110: conditionally_execute = v;             // Overflow
            4'b0111: conditionally_execute = ~v;            // No overflow
            4'b1000: conditionally_execute = ~z & c;        // Unsigned greater-than
            4'b1001: conditionally_execute = z | ~c;        // Unsinged less-than or equal-to
            4'b1010: conditionally_execute = ~(n ^ v);      // Signed greater-than or equal-to 
            4'b1011: conditionally_execute = (n ^ v);       // Signed less-than
            4'b1100: conditionally_execute = ~z & ~(n ^ v); // Signed greater-than
            4'b1101: conditionally_execute = z | (n ^v);    // Signed less than or equal
            4'b1110: conditionally_execute = 1'b1;          // Always
            default: conditionally_execute = 1'bx;          // Not supported
        endcase 

endmodule 
