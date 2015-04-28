//(c) Chris Adams 2015 - Uinversity of Leeds.

//Top level for my really bad synth
`include "constants.v"

module synth (input clk50,
output fpga2dac_t fpga2dac,
output scl,
inout sda
);
		
	//Instantiate the PLL for generating clocks and stuff
	wire clk18_4;
	wire clk25;
	wire locked; //Indicates when PLL is locked. Handy wee reset generator
	wire i2c_end;
	pll_50i_18_4o_25o pll0(
	.areset(0),
	.inclk0(clk50),
	.c0(clk18_4),
	.c1(clk25),
	.locked(locked));
	
	//The arpeggiator just for testing
	wire `key_t key2osc;
	arpeggio(.clk25(clk25), .k(key2osc));
	
	//Instantiate our oscillator to generate a constant sine wave
	wire voltage_dv;
	wire `volt_t osc2gate, gate2adio;
	oscillator osc0(.clk(clk18_4),
	.k(key2osc),
	.v(osc2gate),
	.dv(voltage_dv));
	
	//Reset generator
	reg [7:0]DELAY;
	
	//Oscillator runs at a different clock frequency to DAC I/F so we should use a FIFO
	//No overflow risk since, samples come out very slow.
	//24/04 - Use edge detect for valid signal (requries pipelining) or DV from oscillator?
	//Scrqap that, use DV
	
	//We need to use the i2c module to actually setup the ADC for output
	//Some more awful awful code from terrasic
	//Set sda tri-state
	assign sda = 1'bz; 
	I2C_AV_Config iic0(.iCLK(clk25),
	.I2C_SCLK(scl),
	.I2C_SDAT(sda)
	);
	
	//Gate
	voltage_control(.gate(1), .in(osc2gate), .out(gate2adio));
	
	//Instantiate Terrasic's terrible terrible DAC I/F
	adio_codec ad0(
	.oAUD_DATA(fpga2dac.data),
	.oAUD_LRCK(fpga2dac.lrclk),
	.oAUD_BCK(fpga2dac.bclk),
	.iCLK_18_4(clk18_4),
	.iRST_N(1),
	.sample(gate2adio)
	);
	//Assign our xck
	assign fpga2dac.xck = clk18_4;
	
endmodule