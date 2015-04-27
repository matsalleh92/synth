//This file is a test bench for the oscillator
`include "constants.v"
`timescale 1ns/1ns

module oscillator_tb;

	reg clk25;
	reg `key_t key;
	
	wire [`OSC_DEPTH-1:0] voltage;

	oscillator OSC0(.clk(clk25), .k(key), .v(voltage));
	
	//synthesis translate_off
	
	integer wait_time = `CLK_PRD/2;
	
	//Generate a clock
	always
	begin
		#wait_time clk25 <= 1;
		#wait_time clk25 <= 0; 
	end
	
	//Sweep frequency
	reg [`OSC_WIDTH-1:0] i = 1; 
	real real_f, error;
	integer t1, t2 = 0;
	reg `volt_t voltage_d1, voltage_d2 = 0;
	wire `volt_t q1 = `Q1_SINE;
	wire `volt_t q3 = `Q3_SINE;
	initial
	begin
		t1 = 0;
		t2 = 0;
		key <= 0;
		#400 //Wait 10 ticks for everything to settle
		for(i = 25; i <= 76; i = i + 1)
		begin
			@(posedge clk25) key <= i; 
			//$display("Key is is %d\n", i);
			//We should wait a couple of ticks before continuing
			#80
			//Wait for a falling edge (peak)
			while(voltage >= voltage_d1 || !(voltage > q3))
				@(posedge clk25);
			t1 = $time;
			//Wait for a rising edge (troff)
			while(voltage <= voltage_d1 || !(voltage < q1))
				@(posedge clk25);
				
			//Find our frequency error
			real_f = 1/(($time-t1)*2e-9); //2e-9 because we only measure a half sine
			frequency_error(key, real_f, error);
			
			//Check the actual error
			if(error > 5 || error < -5)
			begin
				$display("Exceeded freq tolerance\n");
				$stop;
			end
		end
		
		$stop("Finished simulation\n");

	end
	
	//This wee function takes key number and finds the correct frequency for error 
	task automatic frequency_error;
	input `key_t k;
	input real this_f;
	output real e;
	real correct_f;
  real diff;
  real key_signed;
	begin
	  key_signed = k;
		correct_f = 0;
		correct_f = (key_signed - 49)/$signed(12);
		correct_f = 1/(2**-correct_f);
		correct_f = 440 * correct_f;
		
		diff = 0;
		diff = correct_f - real_f;
		diff = diff/correct_f;
		
		e = 100 * diff;
		
		$display("key %d, f: %.2fHz, f_fpga: %.2fHz, err: %.2f%%\n", k, correct_f, this_f, e);
		
		end
	endtask
	
	//Use this process to create a delayed version of the voltage for looking for minima and maxima
	always @(posedge clk25)
	begin
		voltage_d1 <= voltage;
		voltage_d2 <= voltage_d1;
	end
	//synthesis translate_on
	
endmodule