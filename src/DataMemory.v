`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:56:10 03/02/2018 
// Design Name: 
// Module Name:    DataMemory 
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

module DataMemory(
	 input clk,
    input rst,
    input Debug_on,
    input [1:0] read_write,
    input [31:0] Debug_read_mem,
    input [31:0] inAddress,
    input [31:0] inWriteData,
    
    //Debug
    input           stop_debug,
    
    output [31:0] outData,
    output [31:0] outMemDebug
    );

// Registros
reg [31:0] Data;
reg [31:0] DataDebug;
integer i;
/*
reg [31:0]New_Data1;
reg [31:0]New_Data2;
reg [31:0]New_Data3;
reg [31:0]New_Data4;
reg [31:0]New_Data5;
reg [31:0]New_Data6;
reg [31:0]New_Data7;
reg [31:0]New_Data8;
reg [31:0]New_Data9;
reg [31:0]New_Data10;
*/
// Asignaciones
assign outData = Data;
assign outMemDebug = DataDebug;
// Matriz de memoria

reg [31:0] data_memory [31:0];


// Logica de Lectura - Escritura de Memoria.
always @(negedge clk, posedge rst)
begin
	if(rst)
	begin
		Data <=32'hZZZZZZZZ;
		/*
		data_memory[0][31:0]<= 32'd2;
		data_memory[1][31:0]<= 32'd4;
		data_memory[2][31:0]<= 32'd6;
		data_memory[3][31:0]<= 32'd8;
		*/
		
		for (i=32'd0; i <= 32'd31; i=i+32'b1)
            begin
               data_memory[i][31:0]<= 32'b0;
            end
            
            //data_memory[20][31:0]<= 32'hAAA;
            
		/*
		New_Data1<=32'h00000000;
		New_Data2<=32'h00000000;
		New_Data3<=32'h00000000;
		New_Data4<=32'h00000104;
		New_Data5<=32'h00000000;
		New_Data6<=32'h00000000;
		New_Data7<=32'h00000107;
		New_Data8<=32'h00000000;
		New_Data9<=32'h00000000;
		New_Data10<=32'h00000000;
		*/
	end
	else
	begin
        if (Debug_on)
            begin
                DataDebug <= data_memory[Debug_read_mem][31:0];                
            end
        else
            begin
                if(!stop_debug)
                begin
                    if(read_write == 2'b01) //Escritura
                       begin
                           data_memory[inAddress][31:0] <= inWriteData;
                       end
                     if(read_write == 2'b10) //Lectura 
                       begin
                            Data <= data_memory[inAddress][31:0];
                       end
                 end
             end
	end
end
					  
endmodule
