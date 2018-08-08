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
    output [14:0] outControl
    );


reg [14:0]Control;

assign outControl=Control;

always @(*)
	begin
		case(inInstruction)// EXE_MEM_WB
			6'd0 	: Control=15'b00_001100_00_000_10;// Instruction TypeR Execute_Memory_WrBack
			6'd35   : Control=15'b00_000001_10_000_11;//Load word
			6'h20   : Control=15'b00_000001_10_101_11;//Load signed byte  
			6'h24   : Control=15'b00_000001_10_001_11;//Load unsigned byte
			6'h21	: Control=15'b00_000001_10_110_11;//Load signed halfword 
			6'h25	: Control=15'b00_000001_10_010_11;//Load unsigned halfword         
			6'h28	: Control=15'b00_000001_01_001_00;//Store
			6'h29	: Control=15'b00_000001_01_010_00;//Store
			6'd43	: Control=15'b00_000001_01_000_00;//Store
			6'd4 	: Control=15'b00_010000_00_000_00;//Branch equal
			6'd5 	: Control=15'b00_110000_00_000_00;//Branch not equal 
			6'd8,6'hc,6'hd,6'he	: Control=15'b00_000111_00_000_10;//Inmediato
			6'd20	 : Control=15'b00_000001_10_000_11;//Load byte????
			6'd2     : Control=15'b10_000000_00_000_01; //Jump
			6'd3     : Control=15'b11_000000_00_000_11; //Jump and Link
			default:
				Control=15'b00_0000_000_000_00;
		endcase
	end

endmodule
