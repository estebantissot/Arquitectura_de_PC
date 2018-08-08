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
    /*
           RegisterMemory[32'd0]=32'b000000_00001_00010_00011_00000_100000;//R-type add;
           RegisterMemory[32'd1]=32'b000000_00001_00010_00100_00000_100010;//R-type sub;
           RegisterMemory[32'd2]=32'b000000_00001_00010_00101_00000_100100;//R-type and
           RegisterMemory[32'd3]=32'b000000_00001_00010_00110_00000_100101;//R-type or
      */
           
        Data <= 32'b0;//RegisterMemory[1'b0];
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
