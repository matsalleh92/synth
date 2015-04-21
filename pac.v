`include "constants.v"

//Phase accumulator

module pac(input clk, input `osc2pac_t f, output reg `pac2sine_approx_t angle = 0);

	//Generate a clock enable first

	integer counter_max = `CLK_FREQ/`PAC_FREQ;
	
	reg [11:0] counter = 0; //Arbitrirarily chosen 8 bit wide counter for counting
	
	reg ce; //When counter reaches limit, we set clock enable and use it other blocks for generation of PCA
	
	always @(posedge clk)
	begin
		if(counter == counter_max)
		begin
			counter <= 0;
			ce <= 1;
		end
		else
		begin
			ce <= 0;
			counter <= counter + 1;
		end
	end
	
	always @(posedge clk)
	begin
		if(ce == 1'b1)
		begin
			angle <= angle == `SINE_WORDS?0:angle + f; //Add f to angle if not saturated
		end
	end

endmodule