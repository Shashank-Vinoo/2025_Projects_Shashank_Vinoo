
module ALU_control(
    input  [1:0] ALU_Op,
    input  [6:0] fun7,
    input  [2:0] fun3,
    output reg [3:0] Control_out
);

    always @(*) begin
        casez ({ALU_Op, fun7, fun3})
            // LW, SW → always add
            12'b00_???????_??? : Control_out = 4'b0010; 

            // BEQ → subtract
            12'b01_???????_??? : Control_out = 4'b0110; 

            // R-type
            12'b10_0000000_000 : Control_out = 4'b0010; // ADD
            12'b10_0100000_000 : Control_out = 4'b0110; // SUB
            12'b10_0000000_111 : Control_out = 4'b0000; // AND
            12'b10_0000000_110 : Control_out = 4'b0001; // OR

            default: Control_out = 4'b0010; // safe default (ADD)
        endcase
    end
endmodule
