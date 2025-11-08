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
			// initialize registers
			Registers[0]  = 0;
			Registers[1]  = 0;  
			Registers[2]  = 0;   
			Registers[3]  = 0;   
			Registers[4]  = 0;   
			Registers[5]  = 5;   
			Registers[8]  = 0;   
			Registers[13] = 0;  
			Registers[16] = 0;  
			Registers[25] = 0;  
			Registers[6]  = 0;
			Registers[7]  = 0;
			Registers[9]  = 0;
			Registers[10] = 10;
			Registers[11] = 0;
			Registers[12] = 0;
			Registers[14] = 0;
			Registers[15] = 0;
			Registers[17] = 0;
			Registers[18] = 0;
			Registers[19] = 0;
			Registers[20] = 0;
			Registers[21] = 0;
			Registers[22] = 0;
			Registers[23] = 0;
			Registers[24] = 0;
			Registers[26] = 0;
			Registers[27] = 0;
			Registers[28] = 0;
			Registers[29] = 0;
			Registers[30] = 0;
			Registers[31] = 0;
		end else if (RegWrite && (Rd!=5'd0)) begin
				  Registers[Rd] <= Write_data;
		end
		Registers[0] <= 32'd0;
	end
	  assign read_data1 = Registers[Rs1];
	  assign read_data2 = Registers[Rs2];
endmodule
