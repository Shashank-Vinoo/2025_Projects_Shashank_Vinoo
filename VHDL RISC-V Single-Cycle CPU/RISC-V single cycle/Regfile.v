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
