module Instruction_Memory(
    input  wire rst,            
    input  wire [31:0] read_address,
    output wire [31:0] instruction_out
);
  reg [31:0] I_Mem [0:63];
  integer i;

  assign instruction_out = I_Mem[read_address[7:2]];

  // Initialize once so contents are known
  always @(posedge rst) begin
	for (i=0; i<64; i=i+1) begin
		I_Mem[i] <= 32'd0;
	end
  end

endmodule
