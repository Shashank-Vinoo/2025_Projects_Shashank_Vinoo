module Data_Memory(
    input  wire clk,
    input  wire rst,            
    input  wire MemWrite,
    input  wire MemRead,
    input  wire [31:0] read_address,
    input  wire [31:0] Write_data,
    output wire [31:0] MemData_out
);

  reg [31:0] D_Memory [0:63];
  integer i;

  // Async read; returns 0 when MemRead=0
  assign MemData_out = MemRead ? D_Memory[read_address[7:2]] : 32'd0;

  // Synchronous write
  always @(posedge clk) begin
    if (MemWrite)
      D_Memory[read_address[7:2]] <= Write_data;
  end

  always @(posedge rst) begin
      for (i=0; i<64; i=i+1) begin
		D_Memory[i] <= 32'd0;
	end
  end
  
endmodule
