module AND(
	input Branch,
	input Zero,
	output reg result  
);

	always @(*) begin
		result = Branch & Zero;
	end

endmodule