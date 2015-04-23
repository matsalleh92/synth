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
	integer real_f;
	integer t1, t2 = 0;
	reg `volt_t voltage_d1 = 0;
	initial
	begin
		v_d1 = 0;
		t1 = 0;
		t2 = 0;
		for(i = 25; i <= 79; i = i + 1)
		begin
			@(posedge clk100) key <= i; 
			$display("Key is is %d\n", i);
			find_frequency(clk100, voltage, real_f);
			$display("Frequency is %d\n", real_f);
		end

	end
	
	//Use this process to create a delayed version of the voltage for looking for minima and maxima
	always @(posedge(clk100)
	begin
		voltage_d1 <= voltage;
	end
	
	//Use this function to find  minima and maxima
	function is_rising;
	input `volt_t v, v_d1;
	begin
		is_rising = v>=v_d1?1'b1:1'b0;
	end
	endfunction
	
	//Use this task to work out the frequency of the sine wave coming out
	task find_frequency;
	input clk;
	input `volt_t v;
	output integer f;
	begin
		$display("Finding frequency\n");
		//reg `volt_t v_d1 = 0;
		//Hold in while loop while voltage is increasing
		while( v >= v_d1)
		begin
			v_d1 = v;
			@(posedge clk);
		end
		//Found a falling edge, take time and back off a clock tick
		t1 = $time - 10;
		$display("Found a falling edge at %dns\n", t1);
		
		//Do the same, but find a troff
		while( v <= v_d1)
		begin
			v_d1 = v;
			@(posedge clk);
		end
		//Found a rising edge, take time and back off a clock tick
		t2 = $time - 10;
		$display("Found a rising edge at %dns\n", t1);
		
		f = 1/(2*(t2*1e-9-t1*1e-9));
		
	end
	endtask
	
endmodule