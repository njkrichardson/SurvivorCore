module testbench_tristate_buffer(); 
    logic           clock, reset; 
    logic [3:0]     a, out, expected; 
    logic           en; 
    logic [31:0]    vector_num, errors; 
    logic [8:0]     test_vectors[32:0]; 

    // instantiate DUT 
    tristate_buffer #(4) dut(a, en, out); 

    // clock generation 
    always 
        begin
            clock = 1; #5; clock = 0; #5; 
        end 

    // load vectors and pulse reset 
    initial 
        begin 
            $display("Reading memory..."); 
            $readmemb("vectors/tristate_buffer_4b.tv", test_vectors, 0, 32);
            $display("Finished reading memory..."); 
            vector_num = 0; errors = 0; 
            reset = 1; #27; reset = 0; 
        end 

    // apply test vectors on rising edge of the clock 
    always @(posedge clock) 
        begin 
            #1; {a, en, expected} = test_vectors[vector_num]; 
        end 

    // check results on falling edge of the clock 
    always @(negedge clock) 
        if (~reset) 
            begin 
            if (out !== expected) 
                begin 
                $display("Error: inputs=%b", {a, en}); 
                $display(" outputs=%b (%b expected)", out, expected); 
                errors = errors + 1; 
                end 
            vector_num = vector_num + 1; 
            if (test_vectors[vector_num] === 9'bx) begin 
                $display("%d tests completed with %d errors", vector_num, errors); 
                $finish; 
            end 
        end 
endmodule 
