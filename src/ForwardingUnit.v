`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/02/2018 05:56:35 PM
// Design Name: 
// Module Name: ForwardingUnit
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


module ForwardingUnit(
    input       rst,
    input [4:0] rs,
    input [4:0] rt,
    input [4:0] MEM_rd,
    input       MEM_regF_wr,
    input [4:0] WB_rd,
    input       WB_regF_wr,
    output[1:0] out_control_muxA,
    output[1:0] out_control_muxB
    );
    
reg [1:0] muxA;
reg [1:0] muxB;
wire ExHazard;

assign out_control_muxA = muxA;
assign out_control_muxB = muxB;
assign ExHazard=(MEM_regF_wr) && (MEM_rd!=0);
    
 always @ (*)
    begin
        if(rst)
            begin
                muxA = 2'b00;
                muxB = 2'b00;
            end
        else
            begin
            if(ExHazard)
                begin
                    if(MEM_rd==rs) muxA = 2'b10;
                    if(MEM_rd==rt) muxB = 2'b10;
                end
       
            if((WB_regF_wr) && (WB_rd!=0) && (!(MEM_rd != rs && ExHazard)))
                begin
                    if(WB_rd==rs) muxA = 2'b01;
                    if(WB_rd==rt) muxB = 2'b01;
                end
            end
    end   
  
endmodule
