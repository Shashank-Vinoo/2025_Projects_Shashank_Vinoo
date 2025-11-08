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
  assign MemData_out = MemRead ? D_Memory[read_address[7:0]] : 32'd0;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        for (i = 0; i < 64; i = i + 1)
            D_Memory[i] <= 32'd0;
    end else if (MemWrite) begin
        D_Memory[read_address[7:0]] <= Write_data;
    end
end



endmodule
