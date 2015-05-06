`include "constants.v"

module pac_container(input clk, output `pac2sine_approx_t angle);

parameter key = 0;

	reg `osc2pac_t f; //Used for driving the PAC with the correct frequency
	
	//Look up table for key to frequency
	//Use a synchronous process for this case statement to help timing. I hear cyclone IIs are shite.
	//Generated using MATLAB script calculate_memory_steps.m
	reg [`PAC_MAX_WIDTH-1:0] pac_max;
	initial
	begin
		case(key)
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
	initial
	begin
		if(key < `TENOR_KEY)
		begin
			pac_max = `VSLOW_PAC_DIV;
		end
		else if(key < `MIDDLE_KEY)
		begin
			pac_max = `SLOW_PAC_DIV;
		end
		else if(key < `SOPRANO_KEY)
		begin
			pac_max = `MED_PAC_DIV;
		end
		else
		begin
			pac_max = `FAST_PAC_DIV;
		end
	end
		
	//Instantiate our PAC
	//Use one pac inside here, leave it free running
	pac PAC0(.clk(clk), .f(f), .pac_max(pac_max), .angle(angle));	
		
endmodule