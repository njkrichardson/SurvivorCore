
module and_gate #(parameter width=1) 
    (
    input logic [width-1:0] a, b, 
    output logic out 
    ); 
    assign out = a & b; 
endmodule 
