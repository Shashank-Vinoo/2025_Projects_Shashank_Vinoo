module rom
		
		#(parameter WIDTH=8, parameter DEPTH = 16, parameter DEPTH_LOG = $clog2(DEPTH))
		(input clk,
		input [DEPTH_LOG-1:0] addr_rd,
		output reg [WIDTH-1:0] data_out
		);
		
		//Declare the ROM array
		reg [WIDTH-1:0] rom [DEPTH_LOG-1:0];
		
		
		//lOADING THE ROM WITH THE DATA FROM rom_init.hex
		//relative location depends on the modelsim project location
		
		initial begin
			$readmemh("place",rom, 0,DEPTH-1);
		end
		
		always @ (posedge clk) begin
			data_out <= rom[addr_rd];
		end
		
endmodule