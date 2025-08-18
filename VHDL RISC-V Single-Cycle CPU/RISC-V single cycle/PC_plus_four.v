//PC + 4: OK; make the 4 explicit width
module PCplus4(
    input  wire [31:0] PC_val,
    output wire [31:0] PC_next_val
);
    assign PC_next_val = PC_val + 32'd4;
endmodule
