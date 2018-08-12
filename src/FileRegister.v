`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:07:06 03/02/2018 
// Design Name: 
// Module Name:    FileRegister 
// Project Name:    TP4-PIPELINE 
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
    
    //Debug
    input           stop_debug,
        
    output [31:0] out_reg1,
    output [31:0] out_reg2,
    output [31:0] out_regDebug
    );
	 
// Registros
reg [31:0] registros[31:0];// Matriz de 32X32
reg [31:0] reg1;
reg [31:0] reg2;
reg [31:0] reg_Debug;

integer i;

// Asignaciones
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
            if(!stop_debug)
                begin
                    reg1 <= registros[read_reg1];
                    reg2 <= registros[read_reg2];
                end
        end
end

// Escritura por flanco ascendente
always@ (posedge clk, posedge rst)
begin
	if (rst)
		begin
            for (i=32'd0; i <= 32'd31; i=i+32'b1)
                begin
                   registros[i][31:0]<= 32'b0;
                end
		end
	else
		begin
			if (write)
				registros[write_addr] <= write_data;// Escribo en la fila indicada por write_addr los 32 bit provenientes de write_data
		end
end
endmodule
