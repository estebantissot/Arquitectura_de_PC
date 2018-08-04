`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:09:24 03/02/2018 
// Design Name: 
// Module Name:    ControlBlock 
// Project Name: 	 MIPS 
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
module ControlBlock(
    input [5:0] inInstruction,
    output [8:0] outControl
    );

reg [8:0]Control;

assign outControl=Control;

always @(*)
	begin
		case(inInstruction)// EXE_MEM_WB
			6'd0 	: Control=9'b1100_000_10;// Instruction TypeR Execute_Memory_WrBack
			6'd35	: Control=9'b0001_010_11;//Load
			6'd43	: Control=9'bX001_001_0X;//Store
			6'd4 	: Control=9'bX010_100_0X;//Branch
			6'd8,6'hc,6'hd,6'he	: Control=9'b0111_000_10;//Inmediato
			6'd20	: Control=9'b0001_010_11;//Load byte????
			6'd2    : Control=9'b0000_000_00;
			default:
				Control=9'b0000_000_00;
		endcase
	end

endmodule
