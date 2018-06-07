`timescale 1ns / 1ps

module Interfaz_Rx(
	
	input 	clk,
	input 	reset,
	
	input 	start,
	input 	[7:0]din,


	output 	MIPS_enable,
	output 	ready,
	output	[31:0]dout,
	);

	reg [7:0] num;	
	reg	[1:0] nData;

	assign dout;

always@(posedge clk)
		begin
			if(reset)
				begin
					nData	<=	2'b00;
					dout	<=	32'b0;
				end
			else
				begin
				if(start)
					begin
						nData	<=	nData+1;
						if(nData != 2'b11)
							begin
								ready	<=	1'b0;
								num		<=	din-48;
								dout	<=	{dout,num};
								dout	<=	dout<<8;
							end
						else
							begin
								ready	<= 1'b1;
							end
					end
				end
		end
		
endmodule
