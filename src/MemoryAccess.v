`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Materia: Arquitectura de Computadoras
// Alumnos: Tissot Esteban
//				Manero Matias
//  
// Create Date:    16:10:47 03/01/2018 
// Design Name: 
// Module Name:    MemoryAccess 
// Project Name: 	 MIPS 
// Description:   
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module MemoryAccess(
//Clock and Reset Signals
    input clk,
    input rst,
	 
//Input Signals
    input [4:0] 	inWB,
    input [1:0] 	inMEM,
    input           inJL,
    input [31:0]    inNextInstructionAddress,
    input [31:0] 	inALUResult,
    input [31:0] 	inRegB,
    input [4:0] 	inRegF_wreg,
    input           Debug_on,
    input   [31:0]  Debug_read_mem,
    
 //Debug
    input           stop_debug,
//Output Signals    
	output  [4:0]	outWB,
    output  [31:0]  outRegF_wd,
    output  [31:0]  outALUResult,
    output  [4:0] 	outRegF_wreg,
    output  [31:0]  outMemDebug
    );

// Registros
reg [4:0]	WB;
//reg [31:0] 	RegF_wd;
reg [31:0] 	ALUResult;
reg [4:0] 	RegF_wreg;
reg [31:0]  RegF_word;
reg JL;

// Cables
wire [1:0]  read_write;
wire [31:0] RegF_wd;

//Asignaciones
assign outWB = WB;
assign outALUResult = ALUResult;
assign outRegF_wreg = (JL) ? 5'd31 : RegF_wreg;
assign read_write = (Debug_on) ? 2'b10:inMEM;
assign outRegF_wd = (JL) ? RegF_word : RegF_wd;


// Instancia de "Data Memory"
DataMemory dm0 (
	.clk(clk),
	.rst(rst),
	.Debug_on(Debug_on),
	.Debug_read_mem(Debug_read_mem),
	.read_write(read_write),
	.inAddress(inALUResult),
	.inWriteData(inRegB),
	.length(inWB[3:2]),
	.stop_debug(stop_debug),
	.outData(RegF_wd),
	.outMemDebug(outMemDebug)
);

// Logica del modulo
always @(negedge clk, posedge rst)
begin
	if(rst)
		begin
			WB <= 4'b0000;
			ALUResult <= 32'b0;
			RegF_wreg <= 5'b0;
			RegF_word <= 32'b0;
			JL <= 0;
		end
	else
		begin
		  if(!stop_debug)
		  begin	
			WB <= inWB;
			ALUResult <= inALUResult;
			JL <= inJL;

           RegF_wreg <= inRegF_wreg;
           RegF_word <= inNextInstructionAddress;


		  end
		end
end

endmodule
