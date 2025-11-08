`timescale 1ns/1ps

module RISCV_TOP_tb;

  reg clk;
  reg rst;

  RISCV_TOP uut (
    .clk(clk),
    .rst(rst)
  );

  // Clock generation (10 ns period)
  always #5 clk = ~clk;

  initial begin
    clk = 0;
    // assert reset at start (active-high)
    rst = 1;
    #20;         // keep reset high for 20 ns
    rst = 0;     // deassert reset

    // run simulation
    #500;
    $display("Simulation finished.");
    $stop;
  end

endmodule
