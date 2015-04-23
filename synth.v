//(c) Chris Adams 2015 - Uinversity of Leeds.

//Top level for my really bad synth

module synth (input clk50,
output fpga2dac
);
	
	//Instantiate Terrasic's terrible terrible DAC I/F
	adio_codec ad0(
	.oAUD_DATA(fpga2dac.data),
	.oAUD_LRCK(fpga2dac.lrclk),
	.oAUD_BCK(fpga2dac.bclk),
	.iCLK_18_4(clk18_4),
	.iRST_N(locked),
	.sample(osc2dac)
	);
	
	//Instantiate the PLL for generating clocks and stuff
	
	
endmodule