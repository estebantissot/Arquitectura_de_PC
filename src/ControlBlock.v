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
    input rst,
    input [31:0] inInstruction,
    output [8:0] outControl
    );


reg [8:0]Control;

assign outControl=Control;

always @ *
	begin
		case(inInstruction[31:26])
			6'd0 	: Control=9'b1100_000_10;// Instruction TypeR Execute_Memory_WrBack
			6'd35	: Control=9'b0001_010_11;//Load
			6'd43	: Control=9'bX001_001_0X;//Store
			6'd4 	: Control=9'bX010_100_0X;//Branch
			6'd8	: Control=9'b1111_000_10;//Inmediato
			6'd20	: Control=9'b0001_010_11;// Load byte
			default:
				Control=9'bXXXX_XXX_XX;
		endcase
	end

endmodule
