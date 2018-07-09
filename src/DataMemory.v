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
    output [31:0] outData,
    output [31:0] outMemDebug
    );

// Registros
reg [31:0] Data;
reg [31:0] DataDebug;
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

reg [7:0] data_memory [31:0];


// Logica de Lectura - Escritura de Memoria.
always @(negedge clk, posedge rst)
begin
	if(rst)
	begin
		Data <=32'hZZZZZZZZ;
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
                if(read_write == 2'b01) //Escritura
                   begin
                       data_memory[inAddress][31:0] <= inWriteData;
                   end
                 if(read_write == 2'b10) //Lectura 
                   begin
                        Data <= data_memory[inAddress][31:0];
                   end
             end
	/*
		case(inAddress)
			32'h00000000:begin
							if(read_write == 2'b01)New_Data1<=inWriteData;
							if(read_write == 2'b10)Data <= New_Data1;
						  end
			32'h00000001:begin
							if(read_write == 2'b01)New_Data2<=inWriteData;
							if(read_write == 2'b10)Data <= New_Data2;
							end	
			32'h00000002:begin
							if(read_write == 2'b01)New_Data3<=inWriteData;
							if(read_write == 2'b10)Data <= New_Data3;
						  end
			32'h00000003:begin
							if(read_write == 2'b01)New_Data4<=inWriteData;
							if(read_write == 2'b10)Data <= New_Data4;
						  end
			32'h00000004:begin
							if(read_write == 2'b01)New_Data5<=inWriteData;
							if(read_write == 2'b10)Data <= New_Data5;
						  end
			32'h00000005:begin
							if(read_write == 2'b01)New_Data6<=inWriteData;
							if(read_write == 2'b10)Data <= New_Data6;
						  end
			32'h00000006:begin
							if(read_write == 2'b01)New_Data7<=inWriteData;
							if(read_write == 2'b10)Data <= New_Data7;
						  end
			32'h00000007:begin
							if(read_write == 2'b01)New_Data8<=inWriteData;
							if(read_write == 2'b10)Data <= New_Data8;
						  end
			32'h00000008:begin
							if(read_write == 2'b01)New_Data9<=inWriteData;
							if(read_write == 2'b10)Data <= New_Data9;
						  end
			32'h00000009:begin
							if(read_write == 2'b01)New_Data10<=inWriteData;
							if(read_write == 2'b10)Data <= New_Data10;
						  end					  
				default: begin
					//if(read_write == 2'b01)defaultvalue<=inWriteData;
					if(read_write == 2'b10)Data <= 32'hZZZZZZZZ;
					if(read_write == 2'b01)Data <= 32'hXXXXXXZZ;
					end
		endcase
		*/
	end
end
					  
endmodule
