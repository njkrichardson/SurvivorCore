module decoder(
    input logic [1:0] operation, 
    input logic [4:0] function, 
    input logic [3:0] destination, 
    output logic [1:0] write_flag, 
    output logic pc_source, 
    output logic write_register, 
    output logic write_memory, 
    output logic memory_to_register, 
    output logic ALU_source, 
    output logic [1:0] immediate_source, 
        register_source, 
        ALU_control
    ); 
    logic [9:0] controls; 
    logic branch, ALU_operation; 

    // Main decoder 
    always_comb 
        casex(operation) 
            2'b00: if (function[5]) controls = 10'b0001_00_1_00_1; // data-processing (immediate) 
                   else             controls = 10'b0000_00_1_00_1; // data-processing (register) 
            2'b01: if (function[0]) controls = 10'b0101_01_1_00_0; // load to register
                   else             controls = 10'b0011_01_0_10_0; // store from register
            2'b10:                  controls = 10'b1001_10_0_01_0; // branch 
            default:                controls = 10'bx; 
        endcase

    assign {branch, memory_to_register, write_memory, ALU_source, immediate_source, write_register, register_source, ALU_operation} = controls; 

    // ALU decoder 

    
    
    // Program counter logic
    assign pc_source = ((destination == 4'b1111) & write_register) | branch; 

endmodule
