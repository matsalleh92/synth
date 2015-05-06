`include "constants.v"

module polyphonic_tb();
	
	//synthesis translate_off
	
	integer wait_time = `CLK_PRD/2;
	
	//Generate a clock
	reg clk;
	always
	begin
		#wait_time clk <= 1;
		#wait_time clk <= 0; 
	end
	
	//synthesis translate_on
	
	polyphonic po0(.clk(clk));
	
		
	
	
endmodule