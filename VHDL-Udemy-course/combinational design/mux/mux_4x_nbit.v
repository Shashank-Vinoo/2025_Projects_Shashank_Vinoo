module mux_4x_nbit
	// Parameter section
	#(parameter BUS_WIDTH = 8)
	// Ports section
	(input [BUS_WIDTH-1:0] a,
	 input [BUS_WIDTH-1:0] b,
	 input [BUS_WIDTH-1:0] c,
	 input [BUS_WIDTH-1:0] d,
	 input [1:0] sel,
	 output reg [BUS_WIDTH-1:0] y);

	always @(*) begin
		case(sel)
			2'd0: y = a;
			2'd1: y = b;
			2'd2: y = c;
			2'd3: y = d;
			default: y = a; // optional fallback
		endcase
	end
endmodule
