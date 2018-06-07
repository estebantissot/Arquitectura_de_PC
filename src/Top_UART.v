`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:31:18 10/18/2017 
// Design Name: 
// Module Name:    Top_UART 
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
module Top_UART(
		input  clk,
		input  reset,
		input  TX_start,
		input  [31:0] UART_data,
		input  RX,
		output MIPS_enable,
		output TX,
		output [31:0]dout
);

wire s_tick;//,transmitir;
wire [7:0] data;
wire [7:0] out_data;

wire tx_done, rx_done, new_result;
wire start_tx;

BRG baud(clk,s_tick);

Interfaz_Rx rx(.clk(clk),.reset(reset),.start(rx_done),.din(data),.MIPS_enable(MIPS_enable));//,data,out_rx,A,B,C);
Receptor rec(clk,reset,RX,s_tick,rx_done,data);


Interfaz_Tx tx(clk,reset,UART_data,TX_start,tx_done,out_data,start_tx);
Transmisor trans(clk,reset,start_tx,s_tick,out_data,tx_done,TX);


endmodule
