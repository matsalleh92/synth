//(c) Chris Adams 2015 - Uinversity of Leeds.

//This module approximates a sine wave using a ROM initialised with a half sine
//Updated to use quater sine to save memory

`include "constants.v"

module sine_approx(input clk, input [`OSC_WIDTH-1:0] angle,
output reg [`OSC_DEPTH-1:0] amp);
	
	//We take incoming angle and mod it, value in this register (one tick delay)
	reg [`QUATER_SINE_WIDTH-1:0] addr_mod;
	
	//This is the output of the memory, needs correcting for full sine wave
	wire [`HALF_SINE_DEPTH-1:0] quater_sine_amp;
	
	//Half sine memory instantiation
	//sine S1(.address(addr_mod), .clock(clk), .q(half_sine_amp));
	//Quater sine memory instantiation
	quater_sine QS0(.address(addr_mod), .clock(clk), .q(quater_sine_amp));
	
	//Mid point
	reg [`OSC_DEPTH-1:0] midpoint = `OSC_AMP_MAX/2;
	
	//Pipeline registers
	reg [`OSC_WIDTH-1:0] angle_d1, angle_d2, angle_d3, angle_d4, angle_d5;
	
	//Main process for working out full sine
	always @(posedge clk)
	begin
		//Delay angle a few times for pipelining
		angle_d1 <= angle;
		angle_d2 <= angle_d1;
		angle_d3 <= angle_d2;
		angle_d4 <= angle_d3;
		angle_d5 <= angle_d4;
	
		if(angle_d3 < 2*`QUATER_SINE_WORDS)
		begin
			//First quater of sine wave, just offset
			amp <= quater_sine_amp + midpoint;
		end
		else
		begin
			amp <= midpoint - quater_sine_amp; // Invert
		end
		
		//Address modding should be done on the non delayed angle
		if(angle < `QUATER_SINE_WORDS || (angle > 2*`QUATER_SINE_WORDS && angle < 3*`QUATER_SINE_WORDS))
		begin
			addr_mod <= angle;
		end
		else
		begin
			//Last quaRter
			addr_mod <= ~(angle % `QUATER_SINE_WORDS); // Count backwards
		end
	end

endmodule