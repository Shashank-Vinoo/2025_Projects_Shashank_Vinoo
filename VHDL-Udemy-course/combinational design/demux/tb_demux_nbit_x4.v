`timescale 1us/1ns

module tb_mux_4x_nbit();

	parameter BUS_WIDTH = 8;
	reg [BUS_WIDTH-1:0] a;
	reg [BUS_WIDTH-1:0] b;
	reg [BUS_WIDTH-1:0] c;
	reg [BUS_WIDTH-1:0] d;
	reg [1:0] sel;
	wire [BUS_WIDTH-1:0] y;
	
	integer i;

	// Instantiate the DUT
	demux_nbit_x4 #(.BUS_WIDTH(BUS_WIDTH)) DEMUX0 (
		.a(a),
		.b(b),
		.c(c),
		.d(d),
		.sel(sel),
		.y(y)
	);
	
	initial begin
		$monitor($time, "sel = %d, y = %d, a = %d, b = %d, c = %d, d = %d", sel, y, a, b, c, d);
		#1; sel = 0; y= 0;
		for (i=0; i<8; i=i+1) begin
			#1; sel = i%4; y = $urandom();
		end
	end
endmodule
		