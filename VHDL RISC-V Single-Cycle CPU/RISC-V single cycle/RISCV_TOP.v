module RISCV_TOP(
	input clk,
	input rst
);

// Instantiation wires
wire [31:0] PC, Instruction, read_data1, read_data2, PCplus4, Sum, mux_two_out;
wire [31:0] Imm_Out, Mux1_Out, Alu_Result, read_data, Write_data;


wire [3:0] ALU_control_signal;

// Control unit wires
wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, Regwrite, zero, AND_Result;
wire [1:0] ALUOp;

// -------------------- Module Instantiations --------------------

// Program Counter
Program_Counter Program_Counter_inst(
	.clk(clk),
	.rst(rst),
	.PC_in(mux_two_out),
	.PC_out(PC)
);

// PC + 4 adder
PCplus4 PCplus4_inst(
	.PC_val(PC),
	.PC_next_val(PCplus4)
);

// Instruction Memory
Instruction_Memory Instruction_Memory_inst(
	.rst(rst), 
	.read_address(PC),
	.instruction_out(Instruction)
);

// Register File
Register_File Register_File_inst(
	.clk(clk), 
	.rst(rst),
	.RegWrite(Regwrite),
	.Rs1(Instruction[19:15]),
	.Rs2(Instruction[24:20]),
	.Rd(Instruction[11:7]),
	.Write_data(Write_data),
	.read_data1(read_data1),
	.read_data2(read_data2)
);

// ALU
ALU_unit ALU_unit_inst(
	.Rd1(read_data1),
	.Rd2_or_Imm(Mux1_Out),
	.control_in(ALU_control_signal), 
	.ALU_result(Alu_Result),
	.zero(zero)
);

// Control Unit
Control_Unit Control_Unit_inst(
	.Instruction(Instruction),
	.Branch(Branch),
	.MemRead(MemRead),
	.MemtoReg(MemtoReg),
	.ALUOp(ALUOp),
	.MemWrite(MemWrite),
	.ALUSrc(ALUSrc),
	.RegWrite(Regwrite)
);

// ALU Control
ALU_control ALU_control_inst(  
	.ALU_Op(ALUOp),
	.fun7(Instruction[31:25]),
	.fun3(Instruction[14:12]),
	.Control_out(ALU_control_signal) 
);

// Data Memory
Data_Memory Data_Memory_inst(
	.clk(clk),
	.rst(rst),
	.MemWrite(MemWrite),
	.MemRead(MemRead),
	.read_address(Alu_Result),
	.Write_data(read_data2),
	.MemData_out(read_data)
);

// Adder for branch target
Adder Adder_inst(
	.PC(PC),
	.Immediate(Imm_Out),
	.Sum(Sum)
);

// Immediate generator
Immgen Immgen_inst(
	.instruction(Instruction),
	.Imm_Out(Imm_Out)
);

// -------------------- Multiplexers --------------------

// Mux1: ALU source select
Mux1 Mux1_inst(
	.sel1(ALUSrc),
	.A1(Imm_Out),
	.B1(read_data2),
	.Mux1_Out(Mux1_Out)
);

// Mux2: PC source select
Mux2 Mux2_inst(
	.sel2(AND_Result),
	.A2(Sum),
	.B2(PCplus4),
	.Mux2_Out(mux_two_out)
);

// Mux3: Write back select
Mux3 Mux3_inst(
	.sel3(MemtoReg),
	.A3(read_data),
	.B3(Alu_Result),
	.Mux3_Out(Write_data)
);

// AND gate for branch decision
AND AND_inst( 
	.Branch(Branch),
	.Zero(zero),
	.result(AND_Result) 
);

endmodule
