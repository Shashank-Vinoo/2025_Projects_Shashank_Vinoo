`timescale 1us/1ns

module ram_sp_async_read(
	input clk,
	input [7:0] data_in,	//8bit input word
	input [3:0] address,	//for 32 locations
	input write_en,			//active high
	output [7:0] data_out	//8 bit output word
);

//Declare a bidirectional array for the ram_sp_async_read

reg [7:0] ram [0:15];

always @(posedge clk) begin
	if (write_en) begin
		ram[address] <= data_in;
	end
end

//The reading is asynchoronus
assign data_out = ram[address];

endmodule