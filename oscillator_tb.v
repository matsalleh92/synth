//This file is a test bench for the oscillator
`include "constants.v"
`timescale 1ns/1ns

module oscillator_tb;

	reg clk100;
	reg `key_t key;
	
	wire [`OSC_DEPTH-1:0] voltage;

	oscillator OSC0(.clk(clk100), .k(key), .v(voltage));
	
	//Generate a clock
	always
	begin
		#5 clk100 <= 1;
		#5 clk100 <= 0; 
	end
	
	//Sweep frequency
	reg [`OSC_WIDTH-1:0] i = 1; 
	initial
	begin
		for(i = 25; i <= 79; i = i + 1)
		begin
			@(posedge clk100) key <= i; 
			$display("Key is is %d\n", i);
			#1000e3;
		end

	end
	
endmodule