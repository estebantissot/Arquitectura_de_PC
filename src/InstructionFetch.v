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
    (*dont_touch="true",mark_debug="true"*)input rst,
	 
//Input Signals
    (*dont_touch="true",mark_debug="true"*)input           inIF_ID_write,
    (*dont_touch="true",mark_debug="true"*)input           inPC_write,
	(*dont_touch="true",mark_debug="true"*)input 			inPCSel,
    (*dont_touch="true",mark_debug="true"*)input [31:0] 	inPCJump,
   // input           inFlush,
    (*dont_touch="true",mark_debug="true"*)input 			stopPC_debug,
    (*dont_touch="true",mark_debug="true"*)input [31:0]    data_instruction,
    (*dont_touch="true",mark_debug="true"*)input           wr_instruction,
 	 
//Output Signals
    (*dont_touch="true",mark_debug="true"*)output [31:0] outInstructionAddress,
    (*dont_touch="true",mark_debug="true"*)output [31:0] outInstruction
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
	.wr_instruction(wr_instruction),
	.data_instruction(data_instruction),
	.inAddr(pc),
	.outData(outInstruction)
);

// Logica del Bloque
always @ (*)
begin
	if(rst)
		instruction_address<=0;
	else
		begin
			casez ({inPCSel,inPC_write})
				2'b00: instruction_address <= pc;
				2'b01: instruction_address <= pc + 1;
				2'b1?: instruction_address <= inPCJump;
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
	else if (inIF_ID_write && (!stopPC_debug))
	//else if (inIF_ID_write)
		begin
			pc <= instruction_address;
			//pc <= pc;
			//instruction <= mem_instruction;
		end
end

endmodule
