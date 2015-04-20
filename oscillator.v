//This module is the actual oscillator implementation. Free runnng, provide frequency and it will provide voltage

`include "constants.v"

module oscillator(input clk, input [`OSC_WIDTH-1:0] f, output [`OSC_DEPTH-1:0] v);
	//Rearchiteching so oscillator uses PCA instead
	
endmodule