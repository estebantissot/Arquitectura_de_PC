`timescale 1ns / 1ps
module BRG(clk,tick);
	parameter FreqClock = 100000000;	//100Mhz
	parameter BaudRate = 19200;	//Frecuencia de muestreo
	parameter Ticks = 16;			//Muestras por BaudRate
	integer contador = 0;
	input clk;
	output reg tick;
	parameter max=FreqClock/(BaudRate*16);
	
	always @(posedge clk) //Memory
	begin
		contador = contador + 1;
		if(contador > 163)
			begin
				tick = 1;
				contador = 0;
			end
		else
			tick = 0;
	end
endmodule
