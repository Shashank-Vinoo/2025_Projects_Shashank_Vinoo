//	Contorl unit
module Control_Unit(
    input  wire [31:0] Instruction,
    output reg Branch,
    output reg MemRead,
    output reg MemtoReg,
    output reg [1:0] ALUOp,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite
);
    wire[6:0] opcode = Instruction[6:0];

    // Opcodes
    localparam OP_RTYPE = 7'b0110011;
    localparam OP_LOAD  = 7'b0000011;
    localparam OP_STORE = 7'b0100011;
    localparam OP_BRANCH= 7'b1100011;

    always @(*) begin
        // safe defaults 
        {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 8'b000000_00;

        case (opcode)
            OP_RTYPE: {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp} = 8'b001000_10;
            OP_LOAD: {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp} = 8'b111100_00; 
            OP_STORE: {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp} = 8'b100010_00; 
            OP_BRANCH: {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp} = 8'b000001_01; 
        endcase
    end
endmodule

//testbench
module main;
reg  [31:0] Instruction;
wire Branch;
wire MemRead;
wire MemtoReg;
wire [1:0] ALUOp;
wire MemWrite;
wire ALUSrc;
wire RegWrite;

//DUT
Control_Unit DUT (
    .Instruction(Instruction),
    .Branch(Branch),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .ALUOp(ALUOp),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite)
);


// Golden Model 
function [7:0] golden_control(input [6:0] opcode);
    begin
        case (opcode)
            7'b0110011: golden_control = 8'b001000_10; // R-type
            7'b0000011: golden_control = 8'b111100_00; // LOAD
            7'b0100011: golden_control = 8'b100010_00; // STORE
            7'b1100011: golden_control = 8'b000001_01; // BRANCH
            default:    golden_control = 8'b000000_00; // Default safe state
        endcase
    end
endfunction


// Comparison task
task compare_data(input [7:0] expected,input [7:0] observed,input [6:0] opcode);
    begin
        if (expected === observed)
            $display($time, " SUCCESS \t opcode=%b \t control=%b", opcode, observed);
        else
            $display($time, " FAILURE \t opcode=%b \t expected=%b, got=%b",opcode, expected, observed);
    end
endtask



reg [7:0] observed;
reg [6:0] opcode;

initial begin

    // T1: R-type
    Instruction = 32'b0000000_00000_00000_000_00000_0110011;
    #1;
    opcode = Instruction[6:0];
    observed = {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp};
    compare_data(golden_control(opcode), observed, opcode);

    // T2: LOAD
    Instruction = 32'b000000000000_00000_000_00000_0000011;
    #1;
    opcode = Instruction[6:0];
    observed = {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp};
    compare_data(golden_control(opcode), observed, opcode);

    // T3: STORE
    Instruction = 32'b0000000_00000_00000_000_00000_0100011;
    #1;
    opcode = Instruction[6:0];
    observed = {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp};
    compare_data(golden_control(opcode), observed, opcode);

    // T4: BRANCH
    Instruction = 32'b0000000_00000_00000_000_00000_1100011;
    #1;
    opcode = Instruction[6:0];
    observed = {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp};
    compare_data(golden_control(opcode), observed, opcode);

    // T5: Unknown opcode
    Instruction = 32'b0000000_00000_00000_000_00000_1111111;
    #1;
    opcode = Instruction[6:0];
    observed = {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp};
    compare_data(golden_control(opcode), observed, opcode);

    $finish;
end

endmodule