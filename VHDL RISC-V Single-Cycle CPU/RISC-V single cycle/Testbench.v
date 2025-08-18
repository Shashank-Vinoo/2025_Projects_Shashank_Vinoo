`timescale 1ns/1ps
module tb;
  reg clock = 0, reset = 0;

  // DUT
  RISCV_TOP CPU (.clk(clock), .rst(reset));

  // 10 ns clock
  always #5 clock = ~clock;


initial begin
  // hold reset active
  reset = 1;
  repeat (2) @(posedge clock); // allow reset to clear regs
  reset = 0;

  // preload AFTER reset
  #1;
  //@ (posedge clock)
  CPU.Register_File_inst.Registers[2] = 32'd99;
  CPU.Instruction_Memory_inst.I_Mem[0] = 32'h00202423; // sw x2, 8(x0)
  CPU.Instruction_Memory_inst.I_Mem[1] = 32'h00000013; // nop
end




  // Let it run a few cycles, then finish
  initial begin
    repeat (8) @(posedge clock);
    $finish;
  end
endmodule



