`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:07:06 03/02/2018 
// Design Name: 
// Module Name:    FileRegister 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module FileRegister(
	 input clk,
    input rst,
    input write,
    input [4:0] read_reg1,
    input [4:0] read_reg2,
    input [4:0] write_addr,
    input [31:0] write_data,
    output [31:0] out_reg1,
    output [31:0] out_reg2
    );
	 

reg [31:0] registros[31:0];// Matriz de 32X32
reg [31:0] reg1;
reg [31:0] reg2;

// Lectura combinacional, manipulado por el clock desendente que se encuentra en el modulo superior
assign out_reg1 = reg1;
assign out_reg2 = reg2;

//Lectura por flanco descendente

always @(negedge clk)
begin
	reg1 <= registros[read_reg1];
	reg2 <= registros[read_reg2];
end


// Escritura por flanco ascendente
always@ (posedge clk, posedge rst)
begin
	if (rst)
		begin
			//[31:0] registros[31:0] = 0;
			registros[0][31:0] <= 32'h00000000;
			registros[1][31:0] <= 32'h00000011;
			registros[2][31:0] <= 32'h00000012;
			registros[3][31:0] <= 32'h00000013;
			registros[4][31:0] <= 32'h00000014;
			registros[5][31:0] <= 32'h00000015;
			registros[6][31:0] <= 32'h00000016;
			registros[7][31:0] <= 32'h00000017;
			registros[8][31:0] <= 32'h00000004;
			registros[9][31:0] <= 32'h00000019;
			registros[10][31:0] <= 32'h00000021;
			registros[11][31:0] <= 32'h00000022;
			registros[12][31:0] <= 32'h00000023;
			registros[13][31:0] <= 32'h00000024;
			registros[14][31:0] <= 32'h00000025;
			registros[15][31:0] <= 32'h00000026;
			registros[16][31:0] <= 32'h00000027;
		end
	else
		begin
			if (write)
				registros[write_addr] <= write_data;// Escribo en la fila indicada por write_addr los 32 bit provenientes de write_data
		end
end
endmodule
