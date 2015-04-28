//(c) Chris Adams 2015 - Uinversity of Leeds.

//Constants
`define CLK_FREQ 18.432e6
`define CLK_PRD 54 //in ns
`define PAC_FREQ 40e3

//Params for communicating with oscillator
`define OSC_DEPTH 16
`define OSC_WIDTH 13
`define OSC_AMP_MAX ((2**`OSC_DEPTH)-1)

//Params for communiting half sine memory
`define HALF_SINE_DEPTH 16
`define HALF_SINE_WIDTH 12
`define HALF_SINE_WORDS ((2**`HALF_SINE_WIDTH)-1)
//Params for the sine approximator
`define SINE_WORDS 8191
`define Q3_SINE 49152
`define Q1_SINE 16384

//Params for MIDI I/F
`define KEY_WIDTH 7

//Definition of types
`define key_t [`KEY_WIDTH-1:0]
`define pac2sine_approx_t [`OSC_WIDTH-1:0]
`define volt_t [`OSC_DEPTH-1:0]
`define osc2pac_t [8:0]

typedef struct packed {
	logic data;
	logic lrclk;
	logic bclk;
	logic xck;
} fpga2dac_t;