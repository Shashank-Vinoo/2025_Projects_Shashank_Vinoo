module counter_nbit
	//paramater
	#( parameter CNT_WIDTH = 3)
	//ports section
	(input clk,
	input reset_n,
	output reg [CNT_WIDTH-1:0] counter);
	//async counter
	always @(posedge clk or negedge reset_n) begin
		if(!reset_n)
			counter <= 0;
		else
			counter <= counter + 1'b1;
	end
	
endmodule