`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:26:27 03/06/2018 
// Design Name: 
// Module Name:    ALU 
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
module ALU #(parameter bits = 8)
(
    A, 
    B,
    select,
    //Zero,
    C
);
		input  signed [bits-1:0]A;
		input  signed [bits-1:0]B;
		input  [3:0]select;
		output [bits-1:0]C;
		//output Zero;
		
		reg [bits-1:0]e;
		reg alu_zero;
		
		always @(*)
		begin
			alu_zero=0;
			case(select)
				4'b0000:e=A&B;
				4'b0001:e=A|B;
				4'b0010:e=A+B;
				4'b0011:e=B>>>A;
				4'b0100:e=B>>A;
				4'b0101:e=~(A|B);
				4'b0110:e=A-B;
				4'b0111:e=-1;
				4'b1001:e=A^B;
				4'b1011:e=B<<A;
				4'b1100: if (A<B) e=32'hffffffff;
				         else e=32'h00000000;
				default: e=-1;
			endcase
		end
		
assign C=e;
//assign Zero = ((select==4'b0110)&&(C == 0))? 1'b1:1'b0;

endmodule

