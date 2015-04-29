//Really basic model for testing our MIDI UART

//Will transmit 10101010 with start and stop bits

`timescale 1ns/1ns
`define wait_tick #32000//One tick at the right frequency

module midi_model(output reg tx);

	//synthesis translate_off
	initial
	begin
		tx <= 0;
		//Wait some time first before starting
		`wait_tick;
		`wait_tick;
		//Continually turn a a key on and off
		while(1)
		begin
			//Wait for everything to settle on the FPGA and then transmit our start bit
			`wait_tick tx <= 1; //Start bit after a long pause
			`wait_tick tx <= 1; //Control bits 7 through zero
			`wait_tick tx <= 0;
			`wait_tick tx <= 0;
			`wait_tick tx <= 1;
			`wait_tick tx <= 0;
			`wait_tick tx <= 0;
			`wait_tick tx <= 0;
			`wait_tick tx <= 0;
			`wait_tick tx <= 1; //Stop bit
			`wait_tick tx <= 0;//Go low
			
			`wait_tick tx <= 1;//Start bit
			`wait_tick tx <= 0;//Key value 7 through 0
			`wait_tick tx <= 0;
			`wait_tick tx <= 1;
			`wait_tick tx <= 0;
			`wait_tick tx <= 1;
			`wait_tick tx <= 0;
			`wait_tick tx <= 1;
			`wait_tick tx <= 0;
			`wait_tick tx <= 1; //Stop bit
			`wait_tick tx <= 0;//Go low
			
			`wait_tick tx <= 1;//Start bit
			`wait_tick tx <= 0;//Velocity value 7 through 0
			`wait_tick tx <= 0;
			`wait_tick tx <= 1;
			`wait_tick tx <= 1;
			`wait_tick tx <= 0;
			`wait_tick tx <= 0;
			`wait_tick tx <= 1;
			`wait_tick tx <= 1;
			`wait_tick tx <= 1; //Stop bit
			`wait_tick tx <= 0;//Go low
			
			//Do exactly the same for note off
			`wait_tick tx <= 1; //Start bit after a long pause
			`wait_tick tx <= 1; //Control bits 7 through zero
			`wait_tick tx <= 0;
			`wait_tick tx <= 0;
			`wait_tick tx <= 0;
			`wait_tick tx <= 0;
			`wait_tick tx <= 0;
			`wait_tick tx <= 0;
			`wait_tick tx <= 0;
			`wait_tick tx <= 1; //Stop bit
			`wait_tick tx <= 0;//Go low
			
			`wait_tick tx <= 1;//Start bit
			`wait_tick tx <= 0;//Key value 7 through 0
			`wait_tick tx <= 0;
			`wait_tick tx <= 1;
			`wait_tick tx <= 0;
			`wait_tick tx <= 1;
			`wait_tick tx <= 0;
			`wait_tick tx <= 1;
			`wait_tick tx <= 0;
			`wait_tick tx <= 1; //Stop bit
			`wait_tick tx <= 0;//Go low
			
			`wait_tick tx <= 1;//Start bit
			`wait_tick tx <= 0;//Velocity value 7 through 0
			`wait_tick tx <= 0;
			`wait_tick tx <= 1;
			`wait_tick tx <= 1;
			`wait_tick tx <= 0;
			`wait_tick tx <= 0;
			`wait_tick tx <= 1;
			`wait_tick tx <= 1;
			`wait_tick tx <= 1; //Stop bit
			`wait_tick tx <= 0;//Go low
		end
		
	end
	//synthesis translate_on

endmodule