//This module is the actual oscillator implementation. Free runnng, provide frequency and it will provide voltage

`include "constants.v"

module oscillator(input clk, input `key_t k, output `volt_t v);
	//Rearchiteching so oscillator uses PAC instead
	
	reg `osc2pac_t f; //Used for driving the PAC with the correct frequency
	
	//Look up table for key to frequency
	//Use a synchronous process for this case statement to help timing. I hear cyclone IIs are shite.
	//Generated using MATLAB script calculate_memory_steps.m
	
	always @(posedge clk)
	begin
		case(k)
			25 : f <= 22;
			26 : f <= 23;
			27 : f <= 25;
			28 : f <= 26;
			29 : f <= 28;
			30 : f <= 30;
			31 : f <= 31;
			32 : f <= 33;
			33 : f <= 35;
			34 : f <= 37;
			35 : f <= 40;
			36 : f <= 42;
			37 : f <= 45;
			38 : f <= 47;
			39 : f <= 50;
			40 : f <= 53;
			41 : f <= 56;
			42 : f <= 60;
			43 : f <= 63;
			44 : f <= 67;
			45 : f <= 71;
			46 : f <= 75;
			47 : f <= 80;
			48 : f <= 85;
			49 : f <= 90;
			50 : f <= 95;
			51 : f <= 101;
			52 : f <= 107;
			53 : f <= 113;
			54 : f <= 120;
			55 : f <= 127;
			56 : f <= 135;
			57 : f <= 143;
			58 : f <= 151;
			59 : f <= 160;
			60 : f <= 170;
			61 : f <= 180;
			62 : f <= 190;
			63 : f <= 202;
			64 : f <= 214;
			65 : f <= 227;
			66 : f <= 240;
			67 : f <= 254;
			68 : f <= 270;
			69 : f <= 286;
			70 : f <= 303;
			71 : f <= 321;
			72 : f <= 340;
			73 : f <= 360;
			74 : f <= 381;
			75 : f <= 404;
			76 : f <= 428;
			default: f <= 0;
		endcase
	end
	
	wire `pac2sine_approx_t angle;
	
	//Instantiate our PAC
	pac PAC0(.clk(clk), .f(f), .angle(angle));
	
	//Link our pac to a sine approximator
	sine_approx SA0(.clk(clk), .angle(angle), .amp(v));
	
endmodule