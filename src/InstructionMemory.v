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
///*          
        RegisterMemory[32'h00]=32'b001000_00000_00001_0000000000001000;     // ADDI R1 R0 8     R1 <- R0(0) + 8
        RegisterMemory[32'h01]=32'b001000_00000_00010_0000000000000011;     // ADDI R2 R0 3     R2 <- R0(0) + 3
        RegisterMemory[32'h02]=32'b001000_00000_00110_0000000000000001;     // ADDI R6 R0 1     R6 <- R0(0) + 1
        RegisterMemory[32'h03]=32'b001000_00000_01001_0000000000001110;     // ADDI R9 R0 14    R9 <- R0(0) + 14
        RegisterMemory[32'h04]=32'b001000_00000_01011_0000000001111111;     // ADDI R11 R0 127  R11 <- R0(0) + 127
        RegisterMemory[32'h05]=32'b001000_00000_01101_0000000000000110;     // ADDI R13 R0 6    R13 <- R0(0) + 6
        RegisterMemory[32'h06]=32'b101011_00110_00001_0000000000000010;     // SW R1 6 2        M3 <- R1(8)   
        RegisterMemory[32'h07]=32'b101011_00010_00110_0000000000000100;     // SW R6 2 4        M7 <- R6(1)
        RegisterMemory[32'h08]=32'b101011_00110_01001_0000000000000011;     // SW R9 6 3        M4 <- R9(14)
        RegisterMemory[32'h09]=32'b101011_00001_01011_0000000000000000;     // SW R11 1 0       M8 <- R11(127)
        RegisterMemory[32'h0a]=32'b000000_01101_00110_00011_00000_100001;   // ADDU R3 R13 R6   R3 <- R13(6) + R6(1)
        RegisterMemory[32'h0b]=32'b000000_00001_01001_00100_00000_100100;   // AND R4 R1 R9     R4 <- R1(8) & R9(14)
        RegisterMemory[32'h0c]=32'b000000_01001_00010_00101_00000_100101;   // OR R5 R9 R2      R5 <- R9(14) | R2(3)  
        RegisterMemory[32'h0d]=32'b000000_00001_01001_00110_00000_100110;   // XOR R6 R1 R9     R6 <- R1(8) XOR R9(14)      
        RegisterMemory[32'h0e]=32'b000100_00001_00011_0000000000010001;     // BEQ R1 R3 17     PC <- 17 SI R3(7) SEA IGUAL A R1(8)
        RegisterMemory[32'h0f]=32'b000000_00110_00011_00011_00000_100001;   // ADDU R3 R6 R3    R3 <- R6(1) + R3(7)
        RegisterMemory[32'h10]=32'b000010_00000000000000000000001011;       // J 11             PC <- 11
        RegisterMemory[32'h11]=32'b000000_00000_00011_00001_00110_000000;   // SLL R1 R3 6      R1[8:0](0000_0110) << 6 = R3[8:0](1000_0000)
        RegisterMemory[32'h12]=32'b000000_00101_00001_00100_00000_100011;   // SUBU R4 R5 R1    (8)R4 - (15)R5 = (-7)R1
        RegisterMemory[32'h13]=32'b100011_00010_01000_0000000000000000;     // LW R8 2 0        R8 <- M2(3)
        RegisterMemory[32'h14]=32'b100000_00000_01100_0000010000000000;     // LB R12 0 1024    R12 <- M8_1(?)
        RegisterMemory[32'h15]=32'b000000_00000_01001_00110_00001_000000;   // SLL R6 R9 1      SLL  R6 R9 1
        RegisterMemory[32'h16]=32'b000000_00000_01001_00110_00001_000000;   // SLL R6 R9 1      SLL  R6 R9 1
        RegisterMemory[32'h17]=32'b000000_00000_01001_00110_00001_000000;   // SLL R6 R9 1      SLL  R6 R9 1
        RegisterMemory[32'h18]=32'b000000_00000_01001_00110_00001_000000;   // SLL R6 R9 1      SLL  R6 R9 1
        RegisterMemory[32'h19]=32'b000000_00000_01001_01010_00001_000011;   // SRA R10 R9 1     R10 <- R9(1110) >> 1

//*/
        for (i=32'h1a; i <= 32'h20; i=i+32'b1)
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
