//ALU
module ALU_unit(
	input signed [31:0] Rd1,
	input signed [31:0] Rd2_or_Imm,
	input [3:0] control_in,
	output reg [31:0] ALU_result,
	output reg zero
	);
	localparam AND = 4'b0000;
	localparam OR = 4'b0001;
	localparam add = 4'b0010;
	localparam subtract = 4'b0110;	
	always @(*)begin
		case(control_in)
			AND: ALU_result = Rd1 & Rd2_or_Imm; 
			OR:ALU_result = Rd1|Rd2_or_Imm;
			add:ALU_result = Rd1+Rd2_or_Imm;
			subtract: ALU_result = Rd1-Rd2_or_Imm;
			default: ALU_result = 32'd0;			
		endcase
		zero = ~|ALU_result;
	end
endmodule

//testbench
module main ();
//tb registers
reg [31:0] Rd1;
reg [31:0] Rd2_or_Imm;
reg [3:0] control_in;
wire [31:0] ALU_result;
wire zero;

//Golden Model
function [32:0] golden_ALU(
    input [3:0] ctrl,
    input signed [31:0] A,
    input signed [31:0] B
);   
    reg [31:0] result;
    reg zflag;
    begin
        case (ctrl)
            4'b0000: result = A & B;// AND
            4'b0001: result = A | B;// OR
            4'b0010: result = A + B;// ADD
            4'b0110: result = A - B;// SUB
            default: result = 32'd0;
        endcase
        zflag = (result == 0);
        golden_ALU = {zflag, result};
    end
endfunction

//comparing golden model with real model
task compare_data(input[32:0]expected_ALU, input[32:0]observed_ALU);
    if(expected_ALU==observed_ALU)begin
        $display($time,"SUCCESS \t expected_ALU=%0d, observed_ALU=%0d",expected_ALU,observed_ALU);
    end else begin
        $display($time,"FALIURE \t expected_ALU=%0d, observed_ALU=%0d",expected_ALU,observed_ALU);
    end
endtask


//DUT instantiation
ALU_unit DUT(
    .Rd1(Rd1),
	.Rd2_or_Imm(Rd2_or_Imm),
	.control_in(control_in),
	.ALU_result(ALU_result),
	.zero(zero)
);


initial begin

    //T1 ADD
    Rd1 = 32'd10; Rd2_or_Imm = 32'd5; control_in = 4'b0010; #1;
    compare_data(golden_ALU(control_in, Rd1, Rd2_or_Imm), {zero, ALU_result});

    //T2 SUB
    Rd1 = 32'd20; Rd2_or_Imm = 32'd20; control_in = 4'b0110; #1;
    compare_data(golden_ALU(control_in, Rd1, Rd2_or_Imm), {zero, ALU_result});

    //T3 AND
    Rd1 = 32'hFFFF0000; Rd2_or_Imm = 32'h00FF00FF; control_in = 4'b0000; #1;
    compare_data(golden_ALU(control_in, Rd1, Rd2_or_Imm), {zero, ALU_result});

    //T4 OR
    Rd1 = 32'h0F0F0F0F; Rd2_or_Imm = 32'hF0F0F0F0; control_in = 4'b0001; #1;
    compare_data(golden_ALU(control_in, Rd1, Rd2_or_Imm), {zero, ALU_result});

    //T5 INVALID CTRL
    Rd1 = 32'd7; Rd2_or_Imm = 32'd3; control_in = 4'b1111; #1;
    compare_data(golden_ALU(control_in, Rd1, Rd2_or_Imm), {zero, ALU_result});

    $finish;
end




endmodule