// Immediate generator
module Immgen(
    input  wire [31:0] instruction,
    output reg  [31:0] Imm_Out
);

    localparam OP_LOAD   = 7'b0000011;
    localparam OP_STORE  = 7'b0100011;
    localparam OP_BRANCH = 7'b1100011;

    always @* begin
        Imm_Out = 32'd0;
        case (instruction[6:0])
            OP_LOAD  : Imm_Out = {{20{instruction[31]}}, instruction[31:20]};                      // I-type
            OP_STORE : Imm_Out = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};   // S-type
            OP_BRANCH: Imm_Out = {{19{instruction[31]}}, instruction[31], instruction[7],
                                   instruction[30:25], instruction[11:8], 1'b0};                   // SB-type
        endcase
    end
endmodule
