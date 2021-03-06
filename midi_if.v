`include "constants.v"
module midi_if(input clk25, input rx, output reg [`NKEYS-1:0] key_status = 0);
	
	//Generate out 31250Hz clock
	integer counter_max = (25e6/31250);
	reg ce = 0;
	reg [9:0] counter = 0;
	always @(posedge clk25)
	begin
		if(counter == counter_max-1)
		begin
			ce <= 1;
			counter <= 0;
		end
		else
		begin
			ce <= 0;
			counter <= counter + 1;
		end
	end
	
	//State machine jazz starts here
	//This process controls the state
	//List state number here
	parameter idle = 2'd0;
	parameter fill = 2'd1;
	
	reg [2:0] state = idle; //,next_state = idle;
	parameter buf_sz = 8;
	reg [buf_sz-1:0] buffer = 0;
	reg [3:0] i = 0; //Needs enough room to include stop bits
	
	reg err, dv;
	reg rx_d1 = 1;
	always @(posedge clk25)
	begin
		if(ce == 1)
		begin
			rx_d1 <= rx;
		end
	
		//state <= next_state;
		
		if(state == idle)
		begin
			err <= 0;
			dv <= 0;
			//Reset data valid and
			if(rx_d1 == 0 && rx == 1)
			begin
				state <= fill;
				i <= 0;
			end
			else
			begin
				state <= idle;
			end
		end
		
		//We took the end of a common UART state machine
		if(state == fill)
		begin
			//Loopback by default
			state <= fill;
			//And tested the rx line...
			if(i == buf_sz && ce == 1)
			begin
				//...We wanted to know if we got a stop bit
				if(rx == 1)
				begin
					err <= 0;
					dv <= 1;
				end
				else
				begin
					//We did not...
					err <= 1;
					dv <= 0;
				end
				//In either case, clear buffer and return to idle
				state <= idle;
			end
			else if(ce == 1)
			begin
				//We're not at the end so go fill that buffer
				buffer[~i[2:0]] <= rx; //Fill backwards
				i <= i + 1;
			end
		end
	end
	
	//This is all byte level processing beyond
	//We only every care about 3 bytes at a time,
	parameter key_on_code = 4'b1001;
	parameter key_off_code = 4'b1000;
	wire key_on; //Indicates that the incoming byte is a control byte
	assign key_on = (buffer[buf_sz-1:4] == key_on_code && dv)?1:0;
	wire key_off;
	assign key_off = (buffer[buf_sz-1:4] == key_off_code && dv)?1:0;
	
	reg [buf_sz-1:0] message [0:2];
	reg [1:0] j = 0; //used for referencing our message
	
	always @(posedge clk25)
	begin
		if(key_on || key_off)
		begin
			//There has been a data valid so store it regardless
			message[0] <= buffer;
			//Its the start of a new message so reset our pointer
			j <= 1;
		end
		else if(j == 3)
		begin
			case(message[0])
				{key_on_code,4'b0000}: key_status[{message[1][buf_sz-1:0]}] <= 1'b1;
				{key_off_code,4'b0000}: key_status[{message[1][buf_sz-1:0]}] <= 1'b0;
				default: $display("This control message has not been implemented yet\n");
			endcase
		end
		else if(dv)
		begin
			message[j] <= buffer;
			j <= j + 1;
		end
	end
	

endmodule