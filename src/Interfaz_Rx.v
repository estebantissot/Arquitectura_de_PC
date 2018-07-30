`timescale 1ns / 1ps

module Interfaz_Rx(
	
	input 	clk,
	input 	reset,
	
	input 	start,
	input 	[7:0] din,

	output 	MIPS_enable,
	 (* dont_touch = "true", mark_debug = "true" *) output 	go,
	output  [31:0] rx_address,
	 (* dont_touch = "true", mark_debug = "true" *) output	[31:0] dout
);

	reg [7:0] 	num;
	reg [31:0]	Data;		
	//reg	[2:0] 	nData;
	//reg 		state;
	reg [1:0]	state_byte;
	reg 		ready;
    reg [31:0]  new_address;
    
	//localparam gather	=	1'b0;
	//localparam send		=	1'b1;

localparam [1:0] first_byte     = 2'b00;
localparam [1:0] second_byte    = 2'b01;
localparam [1:0] third_byte     = 2'b10;
localparam [1:0] fourth_byte    = 2'b11;

	assign dout	=	Data;
	assign go	=	ready;
	assign rx_address = new_address;

always@(posedge clk, posedge reset)
	begin
		if(reset)
			begin
				//nData	<=	3'b0;
				Data	<=	32'b0;
				//state	<=	2'b00;
				ready	<=	1'b0;	
				new_address <= 32'b0;
				state_byte <= first_byte;
			end
		else
			begin
			//case(state)
			//gather:
			//	begin
					if(start)
                        begin
                            case(state_byte)
                                first_byte:
                                    begin
                                        Data[31:24] <=  din - 8'd48;
                                        state_byte <= second_byte;
                                    end
                                second_byte:
                                    begin
                                        Data[23:16] <=  din- 8'd48;
                                        state_byte <= third_byte;                                    
                                    end
                                third_byte:
                                    begin
                                        Data[15:8] <=  din - 8'd48;
                                        state_byte <= fourth_byte;                                    
                                    end
                                fourth_byte:
                                    begin
                                        Data[7:0] <=  din - 8'd48;
                                        state_byte <= first_byte;
                                        ready	<=	1'b1;                                    
                                    end                               
                            endcase
                        end
                    else
                        begin
                            ready	<=	1'b0;
                        end
					/*
					begin
						nData	<=	nData+1;
						if(nData != 3'b100)
							begin
								num		<=	din-8'd48;
								Data	<=	{Data[31:8],num};
								Data	<=	Data<<8;
							end
						else
							begin
							    ready	<=	1'b1;
								nData	<=	3'b000;
								new_address <= new_address +1;
								state	<=	send;
							end
					end
					
					else
                       begin
                            ready	<=	1'b0;
                            state <=    gather;
                        end
                        */					
				end
			
		//	send:
			//	begin
			//		ready	<= 	1'b0;
			//		state 	<=	gather;
		//		end

		//	endcase

		//end
	end		
	
endmodule
