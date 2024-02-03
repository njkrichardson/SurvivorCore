module testbench_and(); 
    logic           clock, reset; 
    logic           a, b, out, expected; 
    logic [31:0]    vector_num, errors; 
    logic [2:0]     test_vectors[0:4]; 

    // instantiate DUT 
    and_gate #(1) dut(a, b, out); 

    // clock generation 
    always 
        begin
            clock = 1; #5; clock = 0; #5; 
        end 

    // load vectors and pulse reset 
    initial 
        begin 
            $display("Reading memory..."); 
            $readmemb("tests/and.tv", test_vectors);
            $display("Finished reading memory..."); 
            vector_num = 0; errors = 0; 
            reset = 1; #27; reset = 0; 
        end 

    // apply test vectors on rising edge of the clock 
    always @(posedge clock) 
        begin 
            #1; {a, b, expected} = test_vectors[vector_num]; 
        end 

    // check results on falling edge of the clock 
    always @(negedge clock) 
        if (~reset) 
            begin 
            if (out !== expected) 
                begin 
                $display("Error: inputs=%b", {a, b}); 
                $display(" outputs=%b (%b expected)", out, expected); 
                errors = errors + 1; 
                end 
            vector_num = vector_num + 1; 
            if (test_vectors[vector_num] === 3'bx) begin 
                $display("%d tests completed with %d errors", vector_num, errors); 
                $finish; 
            end 
        end 
endmodule 
