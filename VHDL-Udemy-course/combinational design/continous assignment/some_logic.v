module some_logic(input a, input b, output c);

	//declaring the internal nets
	wire a_not;
	wire a_or_b;
	
	// The order of the assignments is NOT important
	assign c = a_or_b | (a_or_b & a_not);
	assign a_not = ~a;
	assign a_or_b = a | b;
	
endmodule