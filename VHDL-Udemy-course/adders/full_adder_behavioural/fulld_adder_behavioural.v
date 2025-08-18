module full _adder_behavioural(
	input a,	// always wire
	input b,
	input carry_in,
	// reg because it is used in an always procedure
	output reg sum,
	output reg carry_out,
	);
	
	//Behavioural style
	always @(*) begin
		{carry_out, sum} = a + b + carry_in;
	end
endmodule
	