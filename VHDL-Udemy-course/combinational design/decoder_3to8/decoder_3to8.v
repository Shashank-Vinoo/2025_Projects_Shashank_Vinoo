module decoder_3to8
	(input [2:0]a,input enable, output reg [7:0] y);
	//whenever there is a chnage in the bus 'a' or 'enable' ->execute the always block
	always @(a or enable) begin //wildcard '*'could also be used
		if (enable == 0)
			y = 8b'0;
		else begin
			case (a)	//case statment. check all the 8 combinations
				3'b000 : y = 8'b00000001;
				3'b000 : y = 8'b00000010;
				3'b000 : y = 8'b00000100;
				3'b000 : y = 8'b00001000;
				3'b000 : y = 8'b00010000;
				3'b000 : y = 8'b00100000;
				3'b000 : y = 8'b01000001;
				3'b000 : y = 8'b10000000;
			//PRO Tip: create a defualt calue for output to prevent latch creation
			//You should always use a default
				default : y = 8'b000000000;
			endcase
		end
	end
endmodule
		