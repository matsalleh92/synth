//(c) Chris Adams 2015 - Uinversity of Leeds.

//This module approximates a sine wave using a ROM initialised with a half sine

`include "constants.v"

module sine_approx(input clk, input [`OSC_WIDTH-1:0] angle,
output reg [`OSC_DEPTH-1:0] amp);
	
	//We take incoming angle and mod it, value in this register (one tick delay)
	reg [`HALF_SINE_WIDTH-1:0] addr_mod;
	
	//This is the output of the memory, needs correcting for full sine wave
	wire [`HALF_SINE_DEPTH-1:0] half_sine_amp;
	
	//Half sine memory instantiation
	sine S1(.address(addr_mod), .clock(clk), .q(half_sine_amp));
	
	//Mid point
	reg [`OSC_DEPTH-1:0] midpoint = `OSC_AMP_MAX/2;
	
	//Main process for working out full sine
	always @(posedge clk)
	begin
		if(angle < `HALF_SINE_WORDS)
		begin
			//First half of sine wave, just offset
			amp <= half_sine_amp + midpoint;
		end
		else
		begin
			//LAtter half, so invert
			amp <= midpoint - half_sine_amp;
		end
	
		addr_mod <= angle % `HALF_SINE_WORDS;
	end

endmodule