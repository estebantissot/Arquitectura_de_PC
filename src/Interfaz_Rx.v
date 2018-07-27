`timescale 1ns / 1ps

module Interfaz_Rx(
	
	input 	clk,
	input 	reset,
	
	input 	start,
	input 	[7:0] din,

	output 	MIPS_enable,
	output 	go,
	output  [31:0] rx_address,
	output	[31:0] dout
	);

	reg [7:0] 	num;
	reg [31:0]	Data;		
	reg	[2:0] 	nData;
	reg 		state;
	reg 		ready;
    reg [31:0]  new_address;
	localparam gather	=	1'b0;
	localparam send		=	1'b1;


	assign dout	=	Data;
	assign go	=	ready;
	assign rx_address = new_address;

always@(posedge clk, posedge reset)
	begin
		if(reset)
			begin
				nData	=	3'b0;
				Data	=	32'b0;
				state	=	2'b00;
				new_address = 32'b0;
			end
		else
			begin
			case(state)
			gather:
				begin	
					if(start)
					begin
						nData	=	nData+1;
						if(nData != 3'b101)
							begin
								ready	=	1'b0;
								num		=	din-48;
								Data	=	Data<<8;
								Data	=	{Data[31:8],num};
							end
						else
							begin
								nData	=	3'b000;
								new_address = new_address +1;
								state	=	send;
							end
					end
				end
			
			send:
				begin
					ready	= 	1'b1;
					state 	=	gather;
				end

			endcase

		end
	end		
endmodule
