`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Materia: Arquitectura de Computadoras
// Alumnos: Tissot Esteban
//				Manero Matias
// 
// Create Date:    16:14:59 03/01/2018 
// Design Name:    
// Module Name:    WriteBack 
// Project Name: 	 TP4-PIPELINE 
// Description:   
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module WriteBack(
//Input Signals
    input [4:0]  inWB,
    input signed [31:0] inRegF_wd,
    input [31:0] inALUResult,

//Output Signals
    output 		  outRegF_wr,
    output [31:0] outRegF_wd
    );
	 
//Registros
reg [31:0] RegF_wd;

// Parametros Locales
localparam [31:0] byte = 32'h000f;
localparam [31:0] halfword = 32'h00ff;

//Asignaciones
assign outRegF_wd = RegF_wd;//(inWB[0]) ? inRegF_wd:inALUResult;
assign outRegF_wr = inWB[1];


always @ (*)
begin
	RegF_wd = 32'b0;
	casez({inWB[4:2],inWB[0]})
	   4'b???0:RegF_wd = inALUResult;
	   4'b0001:RegF_wd = inRegF_wd;
	   4'b0011:RegF_wd = inRegF_wd >> 24;
	   4'b0101:RegF_wd = inRegF_wd >> 16;
	   4'b1011:RegF_wd = inRegF_wd >>>  24;
       4'b1101:RegF_wd = inRegF_wd >>>  16;

        default:
            RegF_wd = inALUResult;
	endcase

end
endmodule
