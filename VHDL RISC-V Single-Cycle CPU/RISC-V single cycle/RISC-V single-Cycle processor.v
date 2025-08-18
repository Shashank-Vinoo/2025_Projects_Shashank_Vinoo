// Program counter: OK (async reset high)
module Program_Counter(
    input  wire clk,
    input  wire rst,
    input  wire [31:0] PC_in,
    output reg  [31:0] PC_out
);
    always @(posedge clk or posedge rst) begin
        if (rst)PC_out <= 32'd0;
        else PC_out <= PC_in;
    end
endmodule


//PC + 4: OK; make the 4 explicit width
module PCplus4(
    input  wire [31:0] PC_val,
    output wire [31:0] PC_next_val
);
    assign PC_next_val = PC_val + 32'd4;
endmodule


//Instruction Memory
module Instruction_Memory(
	input rst, 
	input clk,
	input [31:0] read_address,
	output [31:0] instruction_out
);

reg [31:0] I_Mem [63:0];  
integer k;

assign instruction_out = I_Mem[read_address[7:2]];//shifted pc value right to div by 4 and access
//sequential instruction instead of instruction in the memory every 4 lines in the ROM

always @(posedge clk or posedge rst)begin
		if (rst) begin
			for (k = 0; k < 64; k = k + 1) begin 
				I_Mem[k] <= 32'd0;  
			end
		end
end 
endmodule

 
//Register Files
module Register_File(
	input clk,
	input rst,
	input RegWrite,
	input [4:0] Rs1,
	input [4:0] Rs2,
	input [4:0] Rd,
	input [31:0] Write_data,
	output [31:0] read_data1,
	output [31:0] read_data2
);

	reg [31:0] Registers [31:0];
	integer k;
	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
				  for (k = 0; k < 32; k = k + 1) begin
					Registers[k] <= 32'd00;
				  end
				end 
		else if (RegWrite && (Rd!=5'd0)) begin
				  Registers[Rd] <= Write_data;
		end
		
		Registers[0] <= 32'd0;
		
	end

	  assign read_data1 = Registers[Rs1];
	  assign read_data2 = Registers[Rs2];
	  
endmodule

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


// Immediate generator
module Immgen(
    input  wire [31:0] instruction,
    output reg  [31:0] Imm_Out
);

	localparam OP_LOAD  = 7'b0000011;
    localparam OP_STORE = 7'b0100011;
    localparam OP_BRANCH= 7'b1100011;



    always @(*) begin
	Imm_Out = 32'd0;
        case (instruction[6:0])
            OP_LOAD: Imm_Out = {{20{instruction[31]}}, instruction[31:20]};//L-type
            OP_STORE: Imm_Out = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // S-type
            OP_BRANCH: Imm_Out = {{20{instruction[31]}}, instruction[7],instruction[30:25], instruction[11:8], 1'b0};// SB-type
        endcase
    end
endmodule

//ALU
module ALU_unit(
	input [31:0] Rd1,
	input [31:0] Rd2_or_Imm,
	input [3:0] control_in,
	output reg [31:0] ALU_result,
	output reg zero
	);
	
	localparam AND = 4'b0000;
	localparam OR = 4'b0001;
	localparam add = 4'b0010;
	localparam subtract = 4'b0110;
		
	always @(*)begin
		case(control_in)
			AND: ALU_result = Rd1 & Rd2_or_Imm; 
			OR:ALU_result = Rd1|Rd2_or_Imm;
			add:ALU_result = Rd1+Rd2_or_Imm;
			subtract: ALU_result = Rd1-Rd2_or_Imm;
			default: ALU_result = 32'd0;			
		endcase
		zero = ~|ALU_result;
	end
endmodule


//ALU control

module ALU_control(
	input [1:0] ALU_Op,
	input [6:0]fun7,
	input [2:0] fun3,
	output reg [3:0] control_out,
);

    always @(*) begin
        case ({ALU_Op, fun7, fun3})
            6'b00_0_000: Control_out = 4'b0010; // add  (lw/sw)
            6'b01_0_000: Control_out = 4'b0110; // sub  (beq)
            6'b10_0_000: Control_out = 4'b0010; // add
            6'b10_1_000: Control_out = 4'b0110; // sub
            6'b10_0_111: Control_out = 4'b0000; // and
            6'b10_0_110: Control_out = 4'b0001; // or
            default:Control_out = 4'b0010; // add (safe default)
        endcase
    end
endmodule


//Data Memory
module Data_Memory(
	input clk,
	input rst,
	input MemWrite,
	input MemRead,
	input [31:0] read_address,
	input [31:0] Write_data,
	output[31:0] MemData_out
);
reg [31:0] D_Memory [63:0];
integer k;

// async read so loads complete in the same cycle
assign MemData_out = (MemRead) ? D_Memory[read_address[7:2]] : 32'd0;

always @(posedge clk or posedge rst) begin
	
	if(rst) begin
		for (k = 0; k < 64; k = k + 1) begin
			D_Memory[k] <= 32'd0;
		end
	end else if(MemWrite) begin
		D_Memory[read_address[7:2]] <= Write_data;
	end
	
end

endmodule

//multiplexers
module Mux1(
    input  wire sel1,
    input  wire [31:0] A1,
    input  wire [31:0] B1,
    output wire [31:0] Mux1_Out
);
    assign Mux1_Out = sel1 ? A1 : B1;
endmodule

module Mux2(
    input  wire sel2,
    input  wire [31:0] A2,
    input  wire [31:0] B2,
    output wire [31:0] Mux2_Out
);
    assign Mux2_Out = sel2 ? A2 : B2;
endmodule

module Mux3(
    input  wire sel3,
    input  wire [31:0] A3,
    input  wire [31:0] B3,
    output wire [31:0] Mux3_Out
);
    assign Mux3_Out = sel3 ? A3 : B3;
endmodule


//And gate 

module And (
	input Branch,
	input zero,
	output and_out
);

	assign and_out = Branch & zero;

endmodule

//Adder
module Adder(
	input wire[31:0] PC,
	input wire[31:0] Immediate,
	output wire [31:0] Sum
);
	assign Sum = PC+Immediate;
endmodule