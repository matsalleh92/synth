//This module is the actual oscillator implementation. Free runnng, provide frequency and it will provide voltage

`include "constants.v"

module oscillator(input clk, input `key_t k, output `volt_t v, output dv);
	//Rearchiteching so oscillator uses PAC instead
	
	reg `osc2pac_t f; //Used for driving the PAC with the correct frequency
	
	//Look up table for key to frequency
	//Use a synchronous process for this case statement to help timing. I hear cyclone IIs are shite.
	//Generated using MATLAB script calculate_memory_steps.m
	reg [`PAC_MAX_WIDTH-1:0] pac_max;
	always @(posedge clk)
	begin
		case(k)
			25 : f <= 19;
26 : f <= 20;
27 : f <= 21;
28 : f <= 23;
29 : f <= 24;
30 : f <= 26;
31 : f <= 27;
32 : f <= 29;
33 : f <= 31;
34 : f <= 32;
35 : f <= 34;
36 : f <= 36;
37 : f <= 39;
38 : f <= 41;
39 : f <= 43;
40 : f <= 46;
41 : f <= 49;
42 : f <= 52;
43 : f <= 27;
44 : f <= 29;
45 : f <= 31;
46 : f <= 32;
47 : f <= 34;
48 : f <= 36;
49 : f <= 39;
50 : f <= 41;
51 : f <= 43;
52 : f <= 46;
53 : f <= 49;
54 : f <= 52;
55 : f <= 55;
56 : f <= 29;
57 : f <= 31;
58 : f <= 32;
59 : f <= 34;
60 : f <= 36;
61 : f <= 39;
62 : f <= 41;
63 : f <= 43;
64 : f <= 46;
65 : f <= 49;
66 : f <= 52;
67 : f <= 55;
68 : f <= 58;
69 : f <= 15;
70 : f <= 16;
71 : f <= 17;
72 : f <= 18;
73 : f <= 19;
74 : f <= 20;
75 : f <= 21;
76 : f <= 23;

			default: f <= 0;
		endcase
	end
	
	//This process controls what we set our pac_max too
	always @(posedge clk)
	begin
		if(k < `TENOR_KEY)
		begin
			pac_max <= `VSLOW_PAC_DIV;
		end
		else if(k < `MIDDLE_KEY)
		begin
			pac_max <= `SLOW_PAC_DIV;
		end
		else if(k < `SOPRANO_KEY)
		begin
			pac_max <= `MED_PAC_DIV;
		end
		else
		begin
			pac_max <= `FAST_PAC_DIV;
		end
	end
	
	wire `pac2sine_approx_t angle;
	
	//Instantiate our PAC
	//Use one pac and just change limit on the fly
	pac PAC0(.clk(clk), .f(f), .pac_max(pac_max), .angle(angle));
	
	//Link our pac to a sine approximator
	//Voltage not directly linked because needs to ba analysed for change for cross clock stuff
	reg `volt_t v_internal, v_internal_d1;
	sine_approx SA0(.clk(clk), .angle(angle), .amp(v));
	
	/*Use this process to detect a change in the amplitude
	and then fill up a SR to feed to data valid*/
	parameter sr_size = 6;	
	reg [sr_size-1:0] sr;
	integer i;
	
	always @(posedge clk)
	begin
		v_internal_d1 <= v_internal;
		
		if(v_internal_d1 != v_internal)//Change detected, reset our SR
		begin
			sr <= 6'b000111; //This gives 3 ticks for the data to arrive at the FF in slower domain, and two three for DV
		end
		else
		begin
			sr[0] <= 0;
			for(i = 1; i < sr_size; i = i + 1)
			begin
				sr[i] <= sr[i-1];
			end
		end
	end
	
	//Link DV to MSB of SR
	
	assign dv = sr[sr_size-1];
	
	//Cba couble buffering for meta stability
	//assign v = v_internal_d1;
	
endmodule