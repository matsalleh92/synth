//(c) Chris Adams 2015 - Uinversity of Leeds.

//Top level for my really bad synth
`include "constants.v"

module synth (input clk50,
output fpga2dac_t fpga2dac
);
		
	//Instantiate the PLL for generating clocks and stuff
	wire clk18_4;
	wire clk25;
	wire locked; //Indicates when PLL is locked. Handy wee reset generator
	pll_50i_18_4o_25o pll0(
	.inclk0(clk50),
	.c0(clk18_4),
	.c1(clk25),
	.locked(locked));
	
	//Instantiate our oscillator to generate a constant sine wave
	wire voltage_dv;
	wire `volt_t osc2adio;
	oscillator osc0(.clk(clk25),
	.key(49),
	.voltage(osc2adio),
	.dv(voltage_dv));
	
	//Oscillator runs at a different clock frequency to DAC I/F so we should use a FIFO
	//No overflow risk since, samples come out very slow.
	//24/04 - Use edge detect for valid signal (requries pipelining) or DV from oscillator?
	//Scrqap that, use DV
	
	
	//Instantiate Terrasic's terrible terrible DAC I/F
	adio_codec ad0(
	.oAUD_DATA(fpga2dac.data),
	.oAUD_LRCK(fpga2dac.lrclk),
	.oAUD_BCK(fpga2dac.bclk),
	.iCLK_18_4(clk18_4),
	.iRST_N(locked),
	.sample(osc2adio),
	.dv(voltage_dv)
	);
	
endmodule