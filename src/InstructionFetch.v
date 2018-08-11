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
    input           inIF_ID_write,
    input           inPC_write,
	input 			inPCSel,
    input [31:0] 	inPCJump,
   // input           inFlush,
    input 			stop_debug, 
    input           loadProgram,
    input [31:0]    addressInstrucctionProgram,
    input [31:0]    data_instruction,
    input           wr_instruction,
 	 
//Output Signals
    output [31:0] outInstructionAddress,
    output [31:0] outInstruction
    );

// Registros
reg [31:0] pc;
reg [31:0] instruction_address;
reg [31:0] instruction_next;

// Cables
wire [31:0] address;

// Asignaciones
assign outInstructionAddress = instruction_next;
assign address = (loadProgram) ? addressInstrucctionProgram : instruction_address;

// Instancia de "Instruction Memory"
InstructionMemory imem0 (
	.clk(clk),
	.rst(rst),
	.wr_instruction(wr_instruction),
	.data_instruction(data_instruction),
	.inAddr(address),
	.outData(outInstruction)
);

// Logica del Bloque
always @ (*)
begin
	if(rst)
		instruction_address<=0;
	else
		begin
			casez ({stop_debug,inPCSel,inPC_write})
				2'b100: instruction_address <= pc;
				2'b001: instruction_address <= pc + 1;
				2'b01?: instruction_address <= inPCJump;
			endcase
		end
end

always @ (negedge clk, posedge rst)
begin
	if (rst)
		begin
			pc <= 32'hffffffff;
			instruction_next<=32'b0;
		end
	else if (inIF_ID_write)
		begin
			pc <= instruction_address;
			instruction_next<= instruction_address + 1;
		end
end

endmodule
