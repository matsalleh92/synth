`include "constants.v" 

module arpeggio(input clk25, output reg `key_t k);
	//Use the 25MHz clock

	//Generate a 1second long counter
	
	integer count = 0;
	integer count_max = 25e6;
	
	//Counts up to count max
	always @(posedge clk25)	count <= count == count_max?0:count + 1;

	reg [1:0] pointer = 0;
	always @(posedge clk25)
	begin
		if(count == count_max)
			pointer <= pointer + 1; //Will overflow probably
			
		case(pointer)
			0: k <= 28;
			1: k <= 32;
			2: k <= 35;
			3: k <= 40;
		endcase
	end
	
	
endmodule