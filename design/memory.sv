module RAM #(parameter address_width = 6, parameter word_width = 32, parameter num_words = 64) (
    input logic clock,
    input logic write_enable,
    input logic [address_width-1:0] address, 
    input logic [word_width-1:0] data_in, 
    output logic [word_width-1:0] data_out
    ); 
    logic [word_width-1:0] memory [num_words-1:0]; 

    always_ff @(posedge clock)
        if (write_enable) memory[address] <= data_in;
            assign data_out = memory[address];
endmodule

module data_memory #(parameter address_width = 32, parameter word_width = 32, parameter num_words = 64)(
    input logic  clock, write_enable,
    input logic  [address_width-1:0] address, 
    input logic  [word_width-1:0] write_data,
    output logic [word_width-1:0] read_data
    );
    logic [word_width-1:0] RAM[num_words-1:0];
    /* verilator lint_off WIDTH */
    logic [address_width-3:0] word_aligned_address = address[address_width-1:2]; 
    /* lint_on */

    // truncate the least signifcant two bits of the address (word alignment)
    assign read_data = RAM[word_aligned_address]; 

    always_ff @(posedge clock)
        if (write_enable) RAM[word_aligned_address] <= write_data;
endmodule

module instruction_memory #(parameter address_width = 32, parameter word_width = 32, parameter num_words = 64)(
    input  logic [address_width-1:0] address,
    output logic [word_width-1:0] read_data
    );

    /* verilator lint_off WIDTH */
    logic [word_width-1:0] RAM[num_words-1:0];
    logic [address_width-3:0] word_aligned_address = address[address_width-1:2]; 
    /* lint_on */
    initial
        $readmemh("vectors/basic.dat", RAM);

    // truncate the least signifcant two bits of the address (word alignment)
    assign read_data = RAM[word_aligned_address]; 
endmodule
