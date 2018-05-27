`timescale 1ns / 1ps

module Interfaz_Rx(clk,reset,start,din,MIPS_enable);//,din,dout,A,B,C);

	input clk,reset;
	input start;
	input wire[7:0]din;
	//output[7:0]dout;
	output MIPS_enable;
	
	//output A,B,C;
	//reg a_bA,a_bB,a_bC;
	
	//reg [7:0] num;	
	reg aux_start;
	assign MIPS_enable=aux_start;
	
	//assign dout=num;

	//reg[7:0] cnto;
	
	
always@(posedge clk, posedge reset)
	if(reset)
		begin
			//cnto=0;
			aux_start=0;
		end
	else
		begin
			if(1'b1)
				aux_start=1;
		end
		
endmodule
