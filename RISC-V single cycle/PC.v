module Program_Counter(
	input  wire clk,
    input  wire rst,
    input  wire [31:0] PC_in,//32 bit input port
    output reg  [31:0] PC_out//32 bit input port
);

	    always @(posedge clk or posedge rst) begin
			
			if (rst)PC_out <= 32'd0;//if reset assign 32-bit
			
			else PC_out <= PC_in;
		end

endmodule 