`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:35:32 03/13/2018 
// Design Name: 
// Module Name:    ALUControl 
// Project Name: 
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
module ALUControl(
    input  [1:0] inALUop,
    input  [5:0] inInstructionOpcode,
    output [3:0] outALUControl
    );

reg	[3:0] ALUControl;

assign outALUControl = ALUControl;

always @(*)
begin
	casez({inALUop,inInstructionOpcode})
		// Load and Store
		8'b00_??????:	ALUControl = 4'b0010;  // add
		// Branch equal
		8'b01_??????:	ALUControl = 4'b0110; // subtract
		//------------------------------- R-Type ------------------------------------
		8'b10_100000 :	ALUControl = 4'b0010; // add
		8'b10_100010 :	ALUControl = 4'b0110; // subtract
		8'b10_100100 :	ALUControl = 4'b0000; // and
		8'b10_100101 :	ALUControl = 4'b0001; // or
		8'b10_101010 :	ALUControl = 4'b0111; // set on less than
		8'b10_100110 :	ALUControl = 4'b1001; // XOR
		8'b10_100111 : 	ALUControl = 4'b0101; // NOR
		// Shift 
		8'b10_000011 :	ALUControl = 4'b0100; // sra -- Shift right arithmetic
		8'b10_000111 :	ALUControl = 4'b0100; // srav-- Shift right arithmetic varibale
		8'b10_000010 :	ALUControl = 4'b0011; // srl -- Shift right logical
		8'b10_000110 :	ALUControl = 4'b0011; // srlv -- Shift right logical varibale
		8'b10_000000 :	ALUControl = 4'b1011; // sll -- Shift left logical
		8'b10_000100 :	ALUControl = 4'b1011; // sllv -- Shift left logical varibale
		//------------------------------Inmediatos-----------------------------------
		
		8'b11_001000 :	ALUControl = 4'b0010; // add
		8'b11_001100 :	ALUControl = 4'b0000; // and
		8'b11_001101 :	ALUControl = 4'b0001; // or
		8'b11_001110 :	ALUControl = 4'b1001; // XOR
		
		default:			ALUControl= 4'b0010;
	endcase
end


endmodule
