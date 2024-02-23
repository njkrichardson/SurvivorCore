module instruction_decoder(
    input logic [1:0] operation, 
    input logic [5:0] function_field, 
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
        case(operation) 
            2'b00: if (function_field[5]) controls = 10'b0001_00_1_00_1; // data-processing (immediate) 
                   else             controls = 10'b0000_00_1_00_1; // data-processing (register) 
            2'b01: if (function_field[0]) controls = 10'b0101_01_1_00_0; // load to register
                   else             controls = 10'b0011_01_0_10_0; // store from register
            2'b10:                  controls = 10'b1001_10_0_01_0; // branch 
            default:                controls = 10'bx; 
        endcase

    assign {branch, memory_to_register, write_memory, ALU_source, immediate_source, write_register, register_source, ALU_operation} = controls; 

    // ALU decoder 
    always_comb
        if (ALU_operation) begin 
            case(function_field[4:1])
                // function cases 
                4'b0100: ALU_control = 2'b00; // Add 
                4'b0010: ALU_control = 2'b01; // Sub 
                4'b0000: ALU_control = 2'b10; // And
                4'b1100: ALU_control = 2'b11; // Or
                default: ALU_control = 2'bx;  // Not supported 
            endcase 

            // set the condition flag write control 
            write_flag[1] = function_field[0]; 
            write_flag[0] = function_field[0] & (ALU_control == 2'b00 | ALU_control == 2'b01); 
        end else begin 
            ALU_control = 2'b00; // Add 
            write_flag = 2'b00; 
        end 
    
    // Program counter logic
    assign pc_source = ((destination == 4'b1111) & write_register) | branch; 

endmodule
