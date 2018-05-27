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
    input [1:0] 	inWB,
    input [31:0] inRegF_wd,
    input [31:0] inALUResult,

//Output Signals
    output 			outRegF_wr,
    output [31:0] outRegF_wd
    );
	 
//Registros
reg [31:0] RegF_wd;

//Asignaciones
assign outRegF_wd = RegF_wd;//(inWB[0]) ? inRegF_wd:inALUResult;
assign outRegF_wr = inWB[1];


always @ (*)
begin
	if (inWB[0])
		RegF_wd <= inRegF_wd;
	else
		RegF_wd <= inALUResult;
end
endmodule
