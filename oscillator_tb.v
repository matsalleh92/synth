//This file is a test bench for the oscillator
`include "constants.v"
`timescale 1ns/1ns

module oscillator_tb;

	reg clk100;
	reg `key_t key;
	
	wire [`OSC_DEPTH-1:0] voltage;

	oscillator OSC0(.clk(clk100), .k(key), .v(voltage));
	
	//synthesis translate_off
	
	//Generate a clock
	always
	begin
		#5 clk100 <= 1;
		#5 clk100 <= 0; 
	end
	
	//Sweep frequency
	reg [`OSC_WIDTH-1:0] i = 1; 
	real real_f;
	integer t1, t2 = 0;
	reg `volt_t voltage_d1 = 0;
	initial
	begin
		t1 = 0;
		t2 = 0;
		key <= 0;
		#50 //Wait 5 ticks for everything to settle
		for(i = 25; i <= 79; i = i + 1)
		begin
			@(posedge clk100) key <= i; 
			$display("Key is is %d\n", i);
			//Wait for a falling edge (peak)
			while(voltage >= voltage_d1)
				@(posedge clk100);
			t1 = $time;
			//Wait for a rising edge (troff)
			while(voltage <= voltage_d1)
				@(posedge clk100);
				
			//Find our frequency error
			real_f = 1/(($time-t1)*2e-9); //2e-9 because we only measure a half sine
			$display("Frequency is %f, error is %f%%\n", real_f, frequency_error(key, real_f));
		end
		
		$finish("Finished simulation\n");

	end
	
	//This wee function takes key number and finds the correct frequency for error 
	function real frequency_error;
	input `key_t key;
	input real real_f;
	real correct_f;
  real diff;
	begin
		correct_f = ($signed(key) - 49)/$signed(12);
		correct_f = 1/(2**-correct_f);
		correct_f = 440 * correct_f;
		
		diff = correct_f - real_f;
		diff = diff/correct_f;
		
		frequency_error = 100 * diff;
		end
	endfunction
	
	//Use this process to create a delayed version of the voltage for looking for minima and maxima
	always @(posedge clk100)
	begin
		voltage_d1 <= voltage;
	end
	//synthesis translate_on
	
endmodule