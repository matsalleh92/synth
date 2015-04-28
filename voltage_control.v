`include "constants.v"

module voltage_control(input gate, input `volt_t in, output `volt_t out);

	assign out = gate?{4'b0000,in[`OSC_DEPTH-5:0]}:0;
	
endmodule