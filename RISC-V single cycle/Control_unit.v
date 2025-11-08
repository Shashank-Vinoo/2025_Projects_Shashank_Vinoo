//	Contorl unit

module Control_Unit(
    input  wire [31:0] Instruction,
    output reg         Branch,
    output reg         MemRead,
    output reg         MemtoReg,
    output reg  [1:0]  ALUOp,
    output reg         MemWrite,
    output reg         ALUSrc,
    output reg         RegWrite
);
    wire [6:0] opcode = Instruction[6:0];

    // Opcodes
    localparam OP_RTYPE = 7'b0110011;
    localparam OP_LOAD  = 7'b0000011;
    localparam OP_STORE = 7'b0100011;
    localparam OP_BRANCH= 7'b1100011;

    always @(*) begin
        // safe defaults 
        {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 8'b000000_00;

        case (opcode)
            OP_RTYPE:  {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp} = 8'b001000_10;
            OP_LOAD:   {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp} = 8'b111100_00; 
            OP_STORE:  {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp} = 8'b100010_00; 
            OP_BRANCH: {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp} = 8'b000001_01; 
        endcase
    end
endmodule
