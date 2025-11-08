module Instruction_Memory(
    input  wire rst,            
    input  wire [31:0] read_address,
    output wire [31:0] instruction_out
);
  reg [31:0] I_Mem [0:63];
  integer k;

  assign instruction_out = I_Mem[read_address[7:0]];



  // Initialize contents once or on reset
  always @(*) begin
    if (rst) begin
        for (k = 0; k < 64; k = k + 1)
            I_Mem[k] = 32'b0;
    end else begin
        //testing ADD,SUBB,AND,OR
        //I_Mem[0] = 32'b0000000_11001_10000_000_01101_0110011; // add x13, x16, x25
        //I_Mem[1] = 32'b0100000_00011_01000_000_00101_0110011; // sub x5, x8, x3
        //I_Mem[2] = 32'b0000000_00011_00010_111_00001_0110011; // and x1, x2, x3
        //I_Mem[3] = 32'b0000000_00101_00011_110_00100_0110011; // or  x4, x3, x5

        //testing lw
        //I_Mem[0] = 32'b000000000010_00000_010_00001_0000011; // lw x1, 2(x0)

        //testing sw
        //I_Mem[0] = 32'b0000000_00011_00000_010_01010_0100011; // sw x3, 10(x0)

        //Testing BEQ
        // Preload instruction memory
        I_Mem[0] = 32'b0000000_00101_00000_000_00001_0110011; // add x1, x0, x5
        I_Mem[1] = 32'b0000000_00101_00000_000_00010_0110011; // add x2, x0, x5
        I_Mem[2] = 32'b000000_00010_00001_000_00011_1100011;  // beq x1, x2, +3
        I_Mem[3] = 32'b0000000_00101_00000_000_00001_0110011; // add x1, x0, x5 //should not execute
        I_Mem[4] = 32'b0; // blank
        I_Mem[5] = 32'b0000000_01010_00011_000_00011_0110011; // add x3, x3, x10

        for (k = 6 ; k < 64; k = k + 1)
            I_Mem[k] = 32'b0;
    end
  end

endmodule 
 