//This module is the actual oscillator implementation. Free runnng, provide frequency and it will provide voltage

`include "constants.v"

module oscillator(input clk, input [`OSC_WIDTH-1:0] f, output [`OSC_DEPTH-1:0] v);
	reg [`OSC_WIDTH-1:0] angle = 0;
	reg ce; //Used to control the increment of the oscillator, by frequency control process
	reg [`FREQ_COUNTER_WIDTH-1:0] frequency_counter = 0; //This counts from 0 to period of 20000Hz in clk period ticks
	reg [`FREQ_COUNTER_WIDTH-1:0] frequency_counter_limit; //This register holds the value of the counter for one whole cycle for a given freq
	reg [`FREQ_COUNTER_WIDTH-1:0] frequency_counter_delta; //This stores deltas between clock enables. Could feasibly use a smaller counter
	
	
	reg [`OSC_DEPTH-1:0] sine_amp;
	
	//For now, v is just the sine output, square and stuff will be added later
	//assign v = sine_amp;
	
	//Instantiate our sine approximator
	sine_approx SA0(.clk(clk), .angle(angle), .amp(v));
	
	//Use this reg to convert macro to definite bit width
	reg [`HALF_SINE_WIDTH-1:0] freq_ratio = `HALF_SINE_WORDS; //Number by which we divide our counter
	
	//Use this process to generate a clock enable based on the frequency
	always @(posedge clk)
	begin
		frequency_counter_limit <= 100000000/(f*4+100); //Frequcny comes encoded in 4Hz chunks, starting at 100Hz
		frequency_counter_delta <= frequency_counter_limit/freq_ratio;
		
		if(frequency_counter == frequency_counter_delta)
		begin
			frequency_counter <= 0;
			ce <= 1;
		end
		else
		begin
			ce <= 0;
			frequency_counter <= frequency_counter + 1;
		end
	end
	
	//Use this wee process (what do you call them in Verilog?) to generate our increasing angle
	//We don't need reset, because we dont really care where the sine starts
	always @(posedge clk)
	begin
		//If limit then reset, else add 1
		if(ce == 1)
		begin
			angle <= (angle == `HALF_SINE_WORDS*2)?0:angle + 2;
		end
	end
	
endmodule