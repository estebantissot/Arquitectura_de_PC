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
    output [11:0] outControl
    );


reg [11:0]Control;

assign outControl=Control;

always @(*)
	begin
		case(inInstruction)// EXE_MEM_WB
			6'd0 	: Control=12'b1100_000_000_10;// Instruction TypeR Execute_Memory_WrBack
			6'd35   : Control=12'b0001_010_000_11;//Load word
			6'h20   : Control=12'b0001_010_101_11;//Load signed byte  
			6'h24   : Control=12'b0001_010_001_11;//Load unsigned byte
			6'h21	: Control=12'b0001_010_110_11;//Load signed halfword 
			6'h25	: Control=12'b0001_010_010_11;//Load unsigned halfword         
			6'h28	: Control=12'bX001_001_001_0X;//Store
			6'h29	: Control=12'bX001_001_010_0X;//Store
			6'd43	: Control=12'bX001_001_000_0X;//Store
			6'd4 	: Control=12'bX010_100_000_0X;//Branch
			6'd8,6'hc,6'hd,6'he	: 
			          Control=12'b0111_000_000_10;//Inmediato
			6'd20	: Control=12'b0001_010_000_11;//Load byte????
			6'd2    : Control=12'b0000_000_000_00;
			default:
				Control=12'b0000_000_000_00;
		endcase
	end

endmodule
