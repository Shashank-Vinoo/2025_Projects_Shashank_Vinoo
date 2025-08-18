module half_adder_behavioral(input a, input b, output reg sum, output reg carry);
	//behvioral style
	always @(a or b) begin
		sum = a ^ b; //a xor b
		carry = a & b;	//a AND begin
	end
endmodule