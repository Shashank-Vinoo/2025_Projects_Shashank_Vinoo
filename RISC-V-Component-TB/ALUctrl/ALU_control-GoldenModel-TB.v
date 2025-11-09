module ALU_control(
    input  [1:0] ALU_Op,
    input  [6:0] fun7,
    input  [2:0] fun3,
    output reg [3:0] Control_out
);

    always @(*) begin
        casez ({ALU_Op, fun7, fun3})
            // LW, SW → always add
            12'b00_???????_??? : Control_out = 4'b0010; 

            // BEQ → subtract
            12'b01_???????_??? : Control_out = 4'b0110; 

            // R-type
            12'b10_0000000_000 : Control_out = 4'b0010; // ADD
            12'b10_0100000_000 : Control_out = 4'b0110; // SUB
            12'b10_0000000_111 : Control_out = 4'b0000; // AND
            12'b10_0000000_110 : Control_out = 4'b0001; // OR

            default: Control_out = 4'b0010; // safe default (ADD)
        endcase
    end
endmodule


module main;


reg  [1:0] ALU_Op;
reg  [6:0] fun7;
reg  [2:0] fun3;
wire [3:0] Control_out;

//DUT
ALU_control DUT (
    .ALU_Op(ALU_Op),
    .fun7(fun7),
    .fun3(fun3),
    .Control_out(Control_out)
);

// Golden Model Function
function [3:0] golden_ALU_ctrl(
    input [1:0] op,
    input [6:0] f7,
    input [2:0] f3
);
    begin
        casez ({op, f7, f3})
            // LW, SW → ADD
            12'b00_???????_??? : golden_ALU_ctrl = 4'b0010;

            // BEQ → SUB
            12'b01_???????_??? : golden_ALU_ctrl = 4'b0110;

            // R-type operations
            12'b10_0000000_000 : golden_ALU_ctrl = 4'b0010; // ADD
            12'b10_0100000_000 : golden_ALU_ctrl = 4'b0110; // SUB
            12'b10_0000000_111 : golden_ALU_ctrl = 4'b0000; // AND
            12'b10_0000000_110 : golden_ALU_ctrl = 4'b0001; // OR

            default: golden_ALU_ctrl = 4'b0010;
        endcase
    end
endfunction

// Comparison task
task compare_data;
    input [3:0] expected, observed;
    begin
        if (expected === observed)
            $display($time, " SUCCESS \t expected=%b, observed=%b", expected, observed);
        else
            $display($time, " FAILURE \t expected=%b, observed=%b", expected, observed);
    end
endtask



initial begin
    $display("----- Starting ALU Control Verification -----");

    // T1: LW or SW (ALUOp=00)
    ALU_Op = 2'b00; fun7 = 7'b0000000; fun3 = 3'b000; #1;
    compare_data(golden_ALU_ctrl(ALU_Op, fun7, fun3), Control_out);

    // T2: BEQ (ALUOp=01)
    ALU_Op = 2'b01; fun7 = 7'b0000000; fun3 = 3'b000; #1;
    compare_data(golden_ALU_ctrl(ALU_Op, fun7, fun3), Control_out);

    // T3: R-type ADD
    ALU_Op = 2'b10; fun7 = 7'b0000000; fun3 = 3'b000; #1;
    compare_data(golden_ALU_ctrl(ALU_Op, fun7, fun3), Control_out);

    // T4: R-type SUB
    ALU_Op = 2'b10; fun7 = 7'b0100000; fun3 = 3'b000; #1;
    compare_data(golden_ALU_ctrl(ALU_Op, fun7, fun3), Control_out);

    // T5: R-type AND
    ALU_Op = 2'b10; fun7 = 7'b0000000; fun3 = 3'b111; #1;
    compare_data(golden_ALU_ctrl(ALU_Op, fun7, fun3), Control_out);

    // T6: R-type OR
    ALU_Op = 2'b10; fun7 = 7'b0000000; fun3 = 3'b110; #1;
    compare_data(golden_ALU_ctrl(ALU_Op, fun7, fun3), Control_out);

    // T7: Invalid combination (default case)
    ALU_Op = 2'b10; fun7 = 7'b1111111; fun3 = 3'b101; #1;
    compare_data(golden_ALU_ctrl(ALU_Op, fun7, fun3), Control_out);
end

endmodule
