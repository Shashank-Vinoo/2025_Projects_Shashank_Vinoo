//multiplexers
module Mux1(
    input  wire sel1,
    input  wire [31:0] A1,
    input  wire [31:0] B1,
    output wire [31:0] Mux1_Out
);
    assign Mux1_Out = sel1 ? A1 : B1;
endmodule

module Mux2(
    input  wire sel2,
    input  wire [31:0] A2,
    input  wire [31:0] B2,
    output wire [31:0] Mux2_Out
);
    assign Mux2_Out = sel2 ? A2 : B2;
endmodule

module Mux3(
    input  wire sel3,
    input  wire [31:0] A3,
    input  wire [31:0] B3,
    output wire [31:0] Mux3_Out
);
    assign Mux3_Out = sel3 ? A3 : B3;
endmodule