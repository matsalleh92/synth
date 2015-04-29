`include "constants.v"

`timescale 1ns/1ps
//Top level test bench for whole synth. Plays keys over 
module synth_tb;

	//Generate clocks
	//synthesis translate_off
	
	integer wait_time = 20;
	
	//Generate a clock
	reg clk;
	always
	begin
		#wait_time clk <= 1;
		#wait_time clk <= 0; 
	end
	//synthesis translate_on
	
	
	//Instantiate our asynchronous midi model for generating key presses
	wire midi2synth;
	midi_model mm0(.tx(midi2synth));
	
	//Instantiate our actual synth
	midi_if mi0(.clk25(clk), .rx(midi2synth));
endmodule
