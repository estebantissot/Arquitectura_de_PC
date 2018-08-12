`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:01:24 03/02/2018 
// Design Name: 
// Module Name:    InstructionMemory 
// Project Name:    TP4-PIPELINE
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
	
	//Debug unit
    input wr_instruction,
    input [31:0] data_instruction,

    // OUTPUT
    output [31:0] outData
);

// Registros
reg [31:0] RegisterMemory [31:0];
reg [31:0] Data;

integer i;

// Asignaciones
assign outData = Data; 

// Logica del Modulo
always @ (negedge clk, posedge rst)
begin    
    if(rst)
    begin         
        Data <= 32'd0;//RegisterMemory[1'b0];
/*          
        RegisterMemory[32'h00]=32'b001000_00000_00001_0000000000001000;     // addi r1 r0 8
        RegisterMemory[32'h01]=32'b001000_00000_00010_0000000000000011;     // addi r2 r0 3
        RegisterMemory[32'h02]=32'b001000_00000_00110_0000000000000001;     // addi r6 r0 1
        RegisterMemory[32'h03]=32'b001000_00000_01001_0000000000001110;     // addi r9 r0 14
        RegisterMemory[32'h04]=32'b001000_00000_01011_0000000001111111;     // addi r11 r0 127 
        RegisterMemory[32'h05]=32'b001000_00000_01101_0000000000000110;     // addi r13 r0 6
        RegisterMemory[32'h06]=32'b100011_00010_01000_0000000000000000;     // lw r8 r2 0
        RegisterMemory[32'h07]=32'b101011_00110_00001_0000000000000010;     // sw r1 r6 2
        RegisterMemory[32'h08]=32'b101011_00010_00110_0000000000000100;     // sw r6 r2 4
        RegisterMemory[32'h09]=32'b101011_00110_01001_0000000000000011;     // sw r9 r6 3
        RegisterMemory[32'h0a]=32'b101011_00001_01011_0000000000000000;     // sw r11 r1 0
        RegisterMemory[32'h0b]=32'b000000_00110_01101_00011_00000_100001;   // addu r3 r6 r13
        RegisterMemory[32'h0c]=32'b000000_01001_00001_00100_00000_100100;   // and r4 r9 r1
        RegisterMemory[32'h0d]=32'b000000_00010_01001_00101_00000_100101;   // or r5 r2 r9
        RegisterMemory[32'h0e]=32'b000000_01001_00001_00111_00000_100110;   // xor r7 r9 r1
        RegisterMemory[32'h0f]=32'b000100_00001_00011_0000000000000010;     // beq rq r3 2
        RegisterMemory[32'h10]=32'b000000_00011_00000_01101_00000_100001;   // addu r13 r3 r0
        RegisterMemory[32'h11]=32'b000010_00000000000000000000001001;       // j 9
        RegisterMemory[32'h12]=32'b000000_00000_00001_01100_00110_000000;   // sll r12 r1 6
        RegisterMemory[32'h13]=32'b000000_00100_00101_00001_00000_100011;   // subu r1 r4 r5
        RegisterMemory[32'h14]=32'b000000_00000_01001_01010_00001_000011;   // sra r10 r9 1
*/
        for (i=32'd0; i <= 32'd31; i=i+32'b1)
            begin
               RegisterMemory[i][31:0]<= 32'b0;
            end
    end
    else
        begin
            if(wr_instruction)
                RegisterMemory[inAddr] <= data_instruction;
            else
                Data <= RegisterMemory[inAddr];
        end
end

endmodule
