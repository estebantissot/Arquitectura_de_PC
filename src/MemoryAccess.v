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
    input [1:0] 	inWB,
    input [2:0] 	inMEM,
    input [31:0] 	inALUResult,
    input 			inALUZero,
    input [31:0] 	inRegB,
    input [4:0] 	inRegF_wreg,
    input           Debug_on,
    input   [31:0]  Debug_read_mem,
    
 //Debug
    input           stop_debug,
//Output Signals    
	output  [1:0]	outWB,
    output  [31:0]  outRegF_wd,
    output  [31:0]  outALUResult,
    output  [4:0] 	outRegF_wreg,
    output  [31:0]  outMemDebug
    );

// Registros
reg [1:0]	WB;
//reg [31:0] 	RegF_wd;
reg [31:0] 	ALUResult;
reg [4:0] 	RegF_wreg;

// Cables
wire [31:0] dm0_RegF_wd;
wire [1:0]  read_write;

//Asignaciones
assign outWB = WB;
//assign outPCJump = inPCJump;
//assign outPCSel = (inMEM[2] && inALUZero);

//assign outRegF_wd = RegF_wd;
assign outALUResult = ALUResult;
assign outRegF_wreg = RegF_wreg;

assign read_write = (Debug_on) ? 2'b10:inMEM[1:0];

// Instancia de "Data Memory"
DataMemory dm0 (
	.clk(clk),
	.rst(rst),
	.Debug_on(Debug_on),
	.Debug_read_mem(Debug_read_mem),
	.read_write(read_write),
	.inAddress(inALUResult),
	.inWriteData(inRegB),
	.stop_debug(stop_debug),
	.outData(outRegF_wd),
	.outMemDebug(outMemDebug)
);

always @(negedge clk, posedge rst)
begin
	if(rst)
		begin
			WB <= 2'b00;
			//RegF_wd <= 32'bZ;
			ALUResult <= 32'b0;
			RegF_wreg <= 5'b0;
		end
	else
		begin
		  if(!stop_debug)
		  begin	
			WB <= inWB;
			//RegF_wd <= dm0_RegF_wd;
			ALUResult <= inALUResult;
			RegF_wreg <= inRegF_wreg;
		  end
		end
end

endmodule
