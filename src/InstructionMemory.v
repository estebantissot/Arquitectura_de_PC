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
assign outData=Data; 

initial
    begin
	
	 /*for (i=32'd0; i <= 32'd31; i=i+32'b1)
            begin
               RegisterMemory[i][31:0]<= 32'b0;
            end
       */ 
       /*
        RegisterMemory[32'd0]=32'b000000_00001_00010_00011_00000_100000;//R-type add;
        RegisterMemory[32'd1]=32'b000000_00001_00010_00100_00000_100010;//R-type sub;
        RegisterMemory[32'd2]=32'b000000_00001_00010_00101_00000_100100;//R-type and
        RegisterMemory[32'd3]=32'b000000_00001_00010_00110_00000_100101;//R-type or
        RegisterMemory[32'd4]=32'b101011_00000_00011_0000000000000011; // Store base_rt_offset (rt es el registro que contiene el valor a guardar)
        RegisterMemory[32'd5]=32'b100011_00000_00000_0000000000000010; // Load  base_rt_offset (rt es el registro donde se va a guardar el valor traido de memoria)
        RegisterMemory[32'd6]=32'b000000_01000_00111_01001_00000_100000;//R-type add
        RegisterMemory[32'd7]=32'b000000_01000_00111_01010_00000_100000;//R-type add
        RegisterMemory[32'd8]=32'b000000_01000_00111_01011_00000_100000;//R-type add 
        RegisterMemory[32'd9]=32'b000000_01000_00111_01100_00000_100000;//R-type add
        //RegisterMemory[32'd10]=32'b000100_10111_10110_0000000000000100; // branch
        RegisterMemory[32'd10]=32'b000010_00000000000000000000000100; // jump
        RegisterMemory[32'd11]=32'b000000_01000_00000_00100_00000_100000;//R-type add
        RegisterMemory[32'd12]=32'b100011_00000_00010_0000000000000011; // Load
        
        RegisterMemory[32'd13]=32'b001101_11000_10001_0000000000001111;//Y-type ori
        RegisterMemory[32'd14]=32'b001000_11000_11001_0000000000000011;//Y-type addi
        RegisterMemory[32'd15]=32'b001100_11000_11101_0000000000001111;//Y-type andi
        RegisterMemory[32'd16]=32'b000000_10001_00111_01011_00000_100000;
		RegisterMemory[32'd17]=32'b100011_00000_00010_0000000000000011; // Load
        //RegisterMemory[32'd16]=32'b001100_11000_11101_0000000000001111;//Y-type andi
        RegisterMemory[32'd18]=32'b000000_00010_00111_01011_00000_100000;//R-type add
        RegisterMemory[32'd19]=32'b000000_01000_00111_01100_00000_100000;//R-type add

        RegisterMemory[32'd20]=32'b000000_01111_10010_00010_00100_000000;//R-type sll
        RegisterMemory[32'd21]=32'b000000_10011_10010_00010_00000_000100;//R-type slv
        RegisterMemory[32'd22]=32'b000000_10011_10010_00010_01010_000011;//R-type sra
        RegisterMemory[32'd23]=32'b000000_10011_10010_00010_00000_000111;//R-type srav
        RegisterMemory[32'd24]=32'b000000_10011_10010_00010_00111_000010;//R-type srl
        RegisterMemory[32'd25]=32'b000000_10011_10010_00010_00000_000110;//R-type srlv
        */
      

      	//-------------------------LOAD-----------------------------------------------------
		/*	RegisterMemory[32'd1]=32'b100011_00001_00010_0000000000000010; // Load word  
			RegisterMemory[32'd2]=32'b100101_00001_00011_0000000000000011; // Load unsigned halfword 
			RegisterMemory[32'd3]=32'b100001_00001_00100_0000000000000010; // Load signed halfword
			RegisterMemory[32'd4]=32'b100100_00001_00101_0000000000000101; // Load  unsigned byte
			RegisterMemory[32'd5]=32'b100000_00001_00110_0000000000000111; // Load  signed byte
        	RegisterMemory[32'd6]=32'b000000_00001_00010_10000_00000_100000;//R-type add;
			RegisterMemory[32'd7]=32'b000000_00001_00011_10000_00000_100000;//R-type add;
			RegisterMemory[32'd8]=32'b000000_00001_00100_10000_00000_100000;//R-type add;
			RegisterMemory[32'd9]=32'b000000_00001_00101_10000_00000_100000;//R-type add;
			RegisterMemory[32'd10]=32'b000000_00001_00110_10000_00000_100000;//R-type add;
       	*/
       	//----------------------------------------------------------------------------------


       	//-------------------------Store-----------------------------------------------------
			

			RegisterMemory[32'd1]=32'b101011_00001_01000_0000000000001000;//Store word;
			RegisterMemory[32'd2]=32'b101001_00001_01001_0000000000000100;//Store halfword;
			RegisterMemory[32'd3]=32'b101000_00001_01010_0000000000010001;//Store byte;
			

			RegisterMemory[32'd4]=32'b000000_00001_00010_10000_00000_100000;//R-type add;
			RegisterMemory[32'd5]=32'b000000_00001_00011_10000_00000_100000;//R-type add;
			RegisterMemory[32'd6]=32'b000000_00001_00100_10000_00000_100000;//R-type add;
			RegisterMemory[32'd7]=32'b000000_00001_00101_10000_00000_100000;//R-type add;
			RegisterMemory[32'd8]=32'b000000_00001_00110_10000_00000_100000;//R-type add;
			
			RegisterMemory[32'd9]=32'b100011_00001_00010_0000000000001000; // Load word  
        	RegisterMemory[32'd10]=32'b100011_00001_00011_0000000000000000; // Load word
        	RegisterMemory[32'd11]=32'b100011_00001_00100_0000000000000001; // Load word

        	RegisterMemory[32'd12]=32'b000000_10101_01110_10000_00000_100000;//R-type add;
			RegisterMemory[32'd13]=32'b000000_10001_10011_11000_00000_100000;//R-type add;
			RegisterMemory[32'd14]=32'b000000_00010_00100_10000_00000_100000;//R-type add;
			RegisterMemory[32'd15]=32'b000000_00011_00101_10000_00000_100000;//R-type add;
			RegisterMemory[32'd16]=32'b000000_00100_00110_10000_00000_100000;//R-type add;
       	
       	//----------------------------------------------------------------------------------


        /*RegisterMemory[32'd15]=32'b001110_11000_00001_0000000000001111;//Y-type xori
        RegisterMemory[32'd16]=32'b001100_11000_11101_0000000000001111;//Y-type andi
        RegisterMemory[32'd17]=32'b000000_01000_00111_01011_00000_100000;//R-type add
        RegisterMemory[32'd18]=32'b000000_01000_00111_01100_00000_100000;//R-type add
        RegisterMemory[32'd19]=32'b000000_01000_00000_00100_00000_100000;//R-type add
        RegisterMemory[32'd20]=32'b000100_10111_10110_0000000000000010; // Store base_rt_offset (rt es el registro que contiene el valor a guardar)
       	*/

       /* RegisterMemory[32'd10]=
        RegisterMemory[32'd11]=
        RegisterMemory[32'd12]=
        RegisterMemory[32'd13]=*/
    end


always @ (negedge clk, posedge rst)
begin    
    if(rst)
        begin
            Data <= RegisterMemory[1'b0];
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
