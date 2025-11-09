// Immediate generator
module Immgen(
    input  wire [31:0] instruction,
    output reg  [31:0] Imm_Out
);

    localparam OP_LOAD   = 7'b0000011;
    localparam OP_STORE  = 7'b0100011;
    localparam OP_BRANCH = 7'b1100011;
    localparam OP_IMM = 7'b0010011;

    always @* begin
        Imm_Out = 32'd0;
        case (instruction[6:0])
            OP_IMM  :  Imm_Out = {{20{instruction[31]}}, instruction[31:20]};//IMMEDIATE ITYPE
            OP_LOAD  : Imm_Out = {{20{instruction[31]}}, instruction[31:20]}; // I-type
            OP_STORE : Imm_Out = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};// S-type
            OP_BRANCH: Imm_Out = {{19{instruction[31]}}, instruction[31], instruction[7],instruction[30:25], instruction[11:8], 1'b0};// SB-type
			default: Imm_Out = 32'b0; // Default case
        endcase
    end
endmodule

// Testbench
module main();

reg  [31:0] instruction;
wire [31:0] Imm_Out;

// Instantiate DUT
Immgen DUT (
    .instruction(instruction),
    .Imm_Out(Imm_Out)
);

// Golden Model Function

function [31:0] golden_immgen(input [31:0] inst);
    reg [6:0] opcode;
    begin
        opcode = inst[6:0];
        case (opcode)
            7'b0010011: // I-type immediate
                golden_immgen = {{20{inst[31]}}, inst[31:20]};
            7'b0000011: // LOAD
                golden_immgen = {{20{inst[31]}}, inst[31:20]};

            7'b0100011: // STORE (S-type)
                golden_immgen = {{20{inst[31]}}, inst[31:25], inst[11:7]};

            7'b1100011: // BRANCH (SB-type)
                golden_immgen = {{19{inst[31]}}, inst[31], inst[7],
                                 inst[30:25], inst[11:8], 1'b0};

            default:
                golden_immgen = 32'd0;
        endcase
    end
endfunction

//compare task
task compare_data;
    input [31:0] expected, observed;

    begin
        if (expected === observed)
            $display($time, " SUCCESS \t immediate=%0d", observed);
        else
            $display($time, " FAILURE \t expected=%0d, got=%0d", expected, observed);
    end
endtask




initial begin
    $display("----- Starting Immediate Generator Verification -----");

    //T1: I-type (ADDI / OP_IMM)
    instruction = 32'b111111111111_00000_000_00001_0010011; // imm=-1, rd=x1
    #1; 
    compare_data(golden_immgen(instruction), Imm_Out);

    // Test 2: LOAD (LW) 
    instruction = 32'b000000000101_00000_010_00010_0000011; // imm=5
    #1; 
    compare_data(golden_immgen(instruction), Imm_Out);

    // Test 3: STORE (SW) 
    instruction = 32'b0000000_00101_00010_010_00100_0100011; // imm=5
    #1;
    compare_data(golden_immgen(instruction), Imm_Out);

    // Test 4: BRANCH (BEQ) 
    instruction = 32'b1_000000_00010_00001_000_00010_1100011; // imm ~ big positive
    #1; 
    compare_data(golden_immgen(instruction), Imm_Out);

    // Test 5: Default / invalid opcode 
    instruction = 32'b000000000000_00000_000_00000_1111111; // unknown opcode
    #1; 
    compare_data(golden_immgen(instruction), Imm_Out);

    $finish;
end

endmodule
