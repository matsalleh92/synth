//(c) Chris Adams 2015 - Uinversity of Leeds.

//Constants

//Params for communicating with oscillator
`define OSC_DEPTH 16
`define OSC_WIDTH 13
`define OSC_AMP_MAX ((2**`OSC_DEPTH)-1)
//Params for communiting half sine memory
`define HALF_SINE_DEPTH 16
`define HALF_SINE_WIDTH 12
`define HALF_SINE_WORDS ((2**`HALF_SINE_WIDTH)-1)

//Params local to the oscillator
`define FREQ_COUNTER_WIDTH 18

`define CLK_FREQ 100e6

