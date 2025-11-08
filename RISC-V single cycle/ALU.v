//ALU
module ALU_unit(
	input signed [31:0] Rd1,
	input signed [31:0] Rd2_or_Imm,
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
