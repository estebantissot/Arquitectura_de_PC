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
    input  rst,
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
		// R-Type
		8'b10_100000:	ALUControl = 4'b0010; // add
		8'b10_100010:	ALUControl = 4'b0110; // subtract
		8'b10_100100:	ALUControl = 4'b0000; // and
		8'b10_100101:	ALUControl = 4'b0001; // or
		8'b10_101010:	ALUControl = 4'b0111; // set on less than
		default:			ALUControl= 4'b0010;
	endcase
end


endmodule
