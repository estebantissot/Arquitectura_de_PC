`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2018 02:49:43 PM
// Design Name: 
// Module Name: HazarDetectionUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module HazardDetectionUnit(
    input rst,
    input EXE_mem_read,
    input [4:0] rs,
    input [4:0] rt,
    input [4:0] EXE_rd,
    output PCWrite,
    output IF_ID_write,
    output ControlMux
    );

// Registros    
reg pc_write;
reg control_mux;
reg if_id_write;    
    
// Asignaciones
assign PCWrite = pc_write;
assign ControlMux = control_mux;
assign IF_ID_write = if_id_write;     

// La unica instruccion que lee la memoria es el load. 
always @(*)
begin
    if(rst)
        begin
            pc_write <= 1'b0;
            control_mux <= 1'b0;
            if_id_write <= 1'b0;
        end
    
    else if((EXE_mem_read) && ((rs == EXE_rd) || (rt == EXE_rd)))
        begin
            pc_write <= 1'b0;
            control_mux <= 1'b0;
            if_id_write <= 1'b0;
        end
    else
        begin
            pc_write <= 1'b1;
            control_mux <= 1'b1;
            if_id_write <= 1'b1;
        end
end

endmodule



