`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:01:24 03/02/2018 
// Design Name: 
// Module Name:    InstructionMemory 
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
module InstructionMemory(
	input clk,
	input rst,
	input [31:0] inAddr,
	output [31:0] outData
	);


reg [31:0] Data;

assign outData=Data; 


always @ (negedge clk, posedge rst)
begin
	if(rst) 
		begin
			Data=32'd100;
		end
	else
		begin
			case(inAddr)
				32'd0: Data=32'b000000_00001_00010_00011_00000_100000;//R-type add
				32'd1: Data=32'b000000_00011_00010_00100_00000_100010;//R-type sub
				32'd2: Data=32'b000000_00001_00010_00101_00000_100100;//R-type and
				32'd3: Data=32'b000000_00001_00010_00110_00000_100101;//R-type or
				
				32'd4: Data=32'b101011_01000_00011_0000000000000011; // Store base_rt_offset (rt es el registro que contiene el valor a guardar)
				32'd5: Data=32'b100011_01000_00010_0000000000000010; // Load  base_rt_offset (rt es el registro donde se va a guardar el valor traido de memoria)
				
				32'd6: Data=32'b000000_01000_00010_01001_00000_100000;//R-type add
				32'd7: Data=32'b000000_01000_00111_01010_00000_100000;//R-type add
				32'd8: Data=32'b000000_01000_00111_01011_00000_100000;//R-type add
				32'd9: Data=32'b000000_01000_00111_01100_00000_100000;//R-type add
				
				32'd10:Data=32'b100011_01000_00010_0000000000000011; // Load
				
				32'd11: Data=32'b000000_01000_00010_01001_00000_100000;//R-type add
				32'd12: Data=32'b000000_01000_00010_01001_00000_100000;//R-type add
				32'd13: Data=32'b000000_01000_00010_01001_00000_100000;//R-type add
				32'd14: Data=32'b000000_01000_00010_01001_00000_100000;//R-type add
				32'd15: Data=32'b000000_01000_00010_01001_00000_100000;//R-type add

				
				32'd16:Data=32'b000000_00000_00010_00011_00000_100000;//R-type add
				
				/*32'd5: Data=32'b101011_00100_00010_0000000000000001; // Store
				32'd5: Data=32'b101011_00100_00010_0000000000000001; // Store
				32'd5: Data=32'b101011_00100_00010_0000000000000001; // Store
				32'd5: Data=32'b101011_00100_00010_0000000000000001; // Store
				*/
				/*32'd6: Data=32'b000100_00001_00010_0000000000000001; // Branch
				32'd7: Data=32'b000000_00000_00000_0000000000000000;
				32'd8: Data=32'b000000_00000_00000_0000000000000000;
				32'd9:Data=32'b000000_00000_00000_0000000000000000;*/
				default:
					Data=32'd123;
			endcase
		end
end

endmodule
