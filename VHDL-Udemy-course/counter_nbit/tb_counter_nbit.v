`timescale 1us/1ns  // FIXED: use `/`, not `.`

module tb_counter_nbit();

	// Testbench variables
	parameter CNT_WIDTH = 3;
	reg clk = 0;
	reg reset_n;  // FIXED: matches signal name
	wire [CNT_WIDTH-1:0] counter;

	// Instantiate the DUT
	counter_nbit
		#(.CNT_WIDTH(CNT_WIDTH))
		CNT_NBIT0 (
			.clk(clk),
			.reset_n(reset_n),  // FIXED: use lowercase 'n', not 'N'
			.counter(counter)
		);
		
	// Create the clock signal
	always begin
		#0.5 clk = ~clk;
	end
		
	// Create stimulus
	initial begin
		$monitor($time, " counter = %d", counter);
		#1; reset_n = 0;  // Apply reset
		#1; reset_n = 1;  // Release reset
		#20 $stop;        // Stop simulation
	end

endmodule
