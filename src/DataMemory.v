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
    input [1:0]  length,
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

reg word;
reg pos;
// Logica de Lectura - Escritura de Memoria.
always @(negedge clk, posedge rst)
begin
	if(rst)
	begin
		Data <=32'hZZZZZZZZ;
		
		for (i=32'd0; i <= 32'd31; i=i+32'b1)
            begin
               data_memory[i][31:0]<= 32'b0;
            end
            
            //data_memory[20][31:0]<= 32'hAAA;
            
        //------------------Test Load y Store-------------------
        /* 
        
        data_memory[32'd2][31:0]<= 32'hea654321;
        data_memory[32'd3][31:0]<= 32'h0f12ff04;
        data_memory[32'd4][31:0]<= 32'hea654321;
        data_memory[32'd5][31:0]<= 32'habcdfcba;       
        data_memory[32'd6][31:0]<= 32'h000006e0;
        */
        //--------------------------------------------------------
		
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
                    casez({read_write,length,inAddress[1:0]})
                    // Escritura
                    6'b01_01_00:   data_memory[{2'b0,inAddress[31:2]}][7:0] <= inWriteData[7:0];// Primer byte
                    6'b01_01_01:   data_memory[{2'b0,inAddress[31:2]}][15:8] <= inWriteData[7:0];// Segundo byte
                    6'b01_01_10:   data_memory[{2'b0,inAddress[31:2]}][23:16] <= inWriteData[7:0];// Tercer byte
                    6'b01_01_11:   data_memory[{2'b0,inAddress[31:2]}][31:24] <= inWriteData[7:0];//cuarto byte
                    6'b01_10_?0:   data_memory[{1'b0,inAddress[31:1]}][15:0] <= inWriteData[15:0];//primer mitad
                    6'b01_10_?1:   data_memory[{1'b0,inAddress[31:1]}][31:16] <= inWriteData[15:0];//segunda mitad
                    6'b01_00_??:   data_memory[inAddress][31:0] <= inWriteData[31:0];//palabra completa
                    //Lectura
                    6'b10_01_00:   Data[31:24] <= data_memory[{2'b0,inAddress[31:2]}][7:0];//Primer byte
                    6'b10_01_01:   Data[31:24] <= data_memory[{2'b0,inAddress[31:2]}][15:8];// Segundo byte
                    6'b10_01_10:   Data[31:24] <= data_memory[{2'b0,inAddress[31:2]}][23:16];// Tercer byte
                    6'b10_01_11:   Data[31:24] <= data_memory[{2'b0,inAddress[31:2]}][31:24];//cuarto byte
                    6'b10_10_?0:   Data[31:16] <= data_memory[{1'b0,inAddress[31:1]}][15:0];//primer mitad
                    6'b10_10_?1:   Data[31:16] <= data_memory[{1'b0,inAddress[31:1]}][31:16];//segunda mitad
                    6'b10_00_??:   Data <= data_memory[inAddress][31:0];//palabra completa
                    
                    /*if(read_write == 2'b01) //Escritura
                       begin
                           data_memory[inAddress][31:0] <= inWriteData;
                       end
                     if(read_write == 2'b10) //Lectura 
                       begin
                            Data <= data_memory[inAddress][31:0];
                       end
                    */
                    endcase
                 end
             end
	end
end

endmodule
