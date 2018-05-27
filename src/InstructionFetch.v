`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Materia: Arquitectura de Computadoras
// Alumnos: Tissot Esteban
//				Manero Matias
// 
// Create Date:    15:50:01 03/01/2018 
// Design Name: 
// Module Name:    InstructionFetch 
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
module InstructionFetch(
//Clock and Reset Signals
    input clk,
    input rst,
	 
//Input Signals
	 input 			inPCSel,
    input [31:0] 	inPCJump,
	 
//Output Signals
    output [31:0] outInstructionAddress,
    output [31:0] outInstruction
    );

// Registros
reg [31:0] pc;
reg [31:0] instruction_address;
//reg [31:0] instruction;

// Cables
//wire [31:0] mem_instruction;

// Asignaciones
assign outInstructionAddress = pc;
//assign outInstruction = instruction;

// Instancia de "Instruction Memory"
InstructionMemory imem0 (
	.clk(clk),
	.rst(rst),
	.inAddr(instruction_address),
	.outData(outInstruction)
);

// Logica del Bloque
always @ (*)
begin
	if(rst)
		instruction_address<=0;
	else
		begin
			case (inPCSel)
				1'b0: instruction_address <= pc + 1;
				1'b1: instruction_address <= inPCJump;
			endcase
		end
end

always @ (negedge clk, posedge rst)
begin
	if (rst)
		begin
			pc <= 32'd0;
			//instruction <= 32'bX;
		end
	else
		begin
			pc <= instruction_address;
			//instruction <= mem_instruction;
		end
	end
endmodule
