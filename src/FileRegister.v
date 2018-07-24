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
    input [4:0] read_regDebug,
    input [4:0] write_addr,
    input [31:0] write_data,
    input Debug_on,
    output [31:0] out_reg1,
    output [31:0] out_reg2,
    output [31:0] out_regDebug
    );
	 

reg [31:0] registros[31:0];// Matriz de 32X32
reg [31:0] reg1;
reg [31:0] reg2;
reg [31:0] reg_Debug;

// Lectura combinacional, manipulado por el clock desendente que se encuentra en el modulo superior
assign out_reg1 = reg1;
assign out_reg2 = reg2;

assign out_regDebug = reg_Debug;

//Lectura por flanco descendente

always @(negedge clk)
begin
    if (Debug_on)
        begin
            reg_Debug <= registros[read_regDebug];
        end
    else
        begin
            reg1 <= registros[read_reg1];
            reg2 <= registros[read_reg2];
        end
end


// Escritura por flanco ascendente
always@ (posedge clk, posedge rst)
begin
	if (rst)
		begin
			registros[31'd0][31:0] <= 32'h00000001;
			registros[31'd1][31:0] <= 32'h00000011;
			registros[31'd2][31:0] <= 32'h00000012;
			registros[31'd3][31:0] <= 32'h00000013;
			registros[31'd4][31:0] <= 32'h00000014;
			registros[31'd5][31:0] <= 32'h00000015;
			registros[31'd6][31:0] <= 32'h00000016;
			registros[31'd7][31:0] <= 32'h00000017;
			registros[31'd8][31:0] <= 32'h00000004;
			registros[31'd9][31:0] <= 32'h00000019;
			registros[31'd10][31:0] <= 32'h00000021;
			registros[31'd12][31:0] <= 32'h00000013;
			registros[31'd13][31:0] <= 32'h00000024;
			registros[31'd14][31:0] <= 32'h00000025;
			registros[31'd15][31:0] <= 32'h00000026;
			registros[31'd16][31:0] <= 32'h00000027;
            registros[31'd17][31:0] <= 32'h00000000;
            registros[31'd18][31:0] <= 32'h00000000;
            registros[31'd19][31:0] <= 32'h00000000;
            registros[31'd20][31:0] <= 32'h00000000;
            registros[31'd21][31:0] <= 32'd16;
            registros[31'd22][31:0] <= 32'd31;
            registros[31'd23][31:0] <= 32'd31;
            registros[31'd24][31:0] <= 32'h00000024;
            registros[31'd25][31:0] <= 32'h00000012;
            registros[31'd26][31:0] <= 32'h00000000;
            registros[31'd27][31:0] <= 32'h00000028;
            registros[31'd28][31:0] <= 32'h00000029;
            registros[31'd29][31:0] <= 32'h00000000;
            registros[31'd30][31:0] <= 32'h00000000;
            registros[31'd31][31:0] <= 32'd42;  //Z en ascii
		end
	else
		begin
			if (write)
				registros[write_addr] <= write_data;// Escribo en la fila indicada por write_addr los 32 bit provenientes de write_data
		end
end
endmodule
