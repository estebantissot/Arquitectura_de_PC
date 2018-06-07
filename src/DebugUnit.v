`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2018 18:37:22
// Design Name: 
// Module Name: DebugUnit
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


module DebugUnit(
    input clk,
    input rst,
    input RX,
    input [31:0] Instruction,
    input [31:0] MemReg,
    input [31:0] Latch,
    input [31:0] MemReg,
    output TX,
    output soft_rst
    );
    
wire tx_start;
wire MIPS_enable;    

reg start;
reg mode;
reg state_mode;
reg [2:0] state_send;

localparam [2:0] send_init	= 	2'b000;
localparam [2:0] send_reg	=	2'b001;
localparam [2:0] send_latch	=	2'b010;
localparam [2:0] send_mem	=	2'b011;
localparam [2:0] send_clk	=	2'b100;

assign soft_rst = (rst || (!MIPS_enable));
assign tx_start = (Instruction==32'd19)? 1'b1:1'b0;
    
Top_UART uart(.clk(clk),.reset(rst),.TX_start(tx_start),.UART_data(execute0_outALUResult),.RX(RX),.MIPS_enable(MIPS_enable),.TX(TX));

always @ (negedge clk)
begin
	case(state_mode)
	1'b0:
		begin
			if(MIPS_enable)
				mode=

		end
	1'b1:
		begin
			if(mode == 1'b0)
				start=1'b1
			else
				begin
					if(Instruction=32'b0)// Instruccion de HALT
						start=1'b1;
					else
						start=1'b0;
				end
		end
end



always @ (posedge clk)
begin
	case(send_init)
		begin
			start

		end
end




    
endmodule
