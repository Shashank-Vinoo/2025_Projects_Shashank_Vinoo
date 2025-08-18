module Adder(
	input wire[31:0] PC,
	input wire[31:0] Immediate,
	output wire [31:0] Sum
);
	assign Sum = PC+Immediate;
endmodule