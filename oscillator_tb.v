//This file is a test bench for the oscillator
`include "constants.v"
`timescale 1ns/1ns

module oscillator_tb;

	reg clk100;
	reg [`OSC_WIDTH-1:0] frequency;
	
	wire [`OSC_DEPTH-1:0] voltage;

	oscillator OSC0(.clk(clk100), .f(frequency), .v(voltage));
	
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
		for(i = 0; i < (2**`OSC_WIDTH)-1; i = i + 1)
		begin
			@(posedge clk100) frequency <= i; 
			$display("Frequency is %dHz\n", i);
			#100e3;
		end

	//frequency <= 2475; //10kHz

	end
	
endmodule