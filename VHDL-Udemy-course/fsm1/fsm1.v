module fsm1(
	input clk,
	input rst_n,
	input validate_code,
	input [3:0] access_code,
	output reg open_access_door,
	output [1:0] state_out
);

//Declare the state values as parameters
parameter [1:0] IDLE == 2'b0, CHECK_CODE == 2'b01, ACCESS_GRANTED == 2'b10;

//Declare the logiv for the state machine
reg [1:0] state;	//The sequential part
reg [1:0] next_state; //The combinational part

reg [3:0] timer; // The counter that keeps the gate open count 15 clocks



//Next state logic
always @(*) begin
	//setting up the default values
	next_state = IDLE;
	open_access_door = 0;//door is closed
	
	case(state)
		IDLE	:begin
					if (validate_code) next_state = CHECK_CODE;
				end
		CHECK_CODE	:begin
						if ((access_code >= 4'd4) && (access_code <= 4'd11))
							next_state = ACCESS_GRANTED;
					end
		ACCESS_GRANTED :begin
							open_access_door = 1;
							if (timer == 4'hF) next_state = IDLE;
							else	next_state = ACCESS_GRANTED;
						end
		default: next_state = IDLE; //best practice
	endcase

end


//state sequnecer logic
always @(posedge clk or negede rst_n) begin
	if(!rst_n)
		state <= IDLE;
	else
		state <= next_state;
end

assign state_out = state;//connect with the output port

//timer logic
always @(posedge clk or negedge rst_n) begin

	if(!rst_n)
		timer <=0;
	else if (state == ACCESS_GRANTED)
		timer <= timer + 1'b1;// incrment timer only in htis state
	else
		timer <= 0;
	end
end


    initial begin
	    $monitor($time, " access_code = %4b, state_out = %2b, open_access_door = %b", 
		                access_code, state_out, open_access_door);
		
	    rst_n = 0; #2.5; rst_n = 1;   // reset sequence
		validate_code = 0; access_code = 0;
	    @(posedge clk);               // invalid access_code
		validate_code = 1; access_code = 0;
	    @(posedge clk);               // invalid access_code
		validate_code = 1; access_code = 0;
	    @(posedge clk);               // valid access_code
		validate_code = 1; access_code = 9;
	    @(posedge clk);               // disable validate_code
		validate_code = 0; access_code = 9;
	    #40 $stop;
	end   







endmodule
	





