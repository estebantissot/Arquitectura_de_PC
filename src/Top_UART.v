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
        
        //output rx_done,
		output MIPS_enable,
		output TX,
		output [31:0] rx_address,
		output write,
		output [31:0] dout,
		output tx_dataready
);

wire s_tick;//,transmitir;
wire [7:0] data;
wire [7:0] out_data;

wire tx_done, rx_done, new_result;
wire start_tx;

BRG baud(clk,s_tick);

Interfaz_Rx rx(
    .clk(clk),
    .reset(reset),
    .start(rx_done),
    .din(data),
    .MIPS_enable(MIPS_enable),
    .go(write),
    .rx_address(rx_address),
    .dout(dout)
);//,data,out_rx,A,B,C);

Receptor rec(clk,reset,RX,s_tick,rx_done,data);

Interfaz_Tx tx(
    .clk(clk),
    .reset(reset),
    
    .in_data(UART_data),
    .new_result(TX_start),
    .tx_done(tx_done),
    // Output
    .out_data(out_data),
    .tx_start(start_tx),
    .data_done(tx_dataready)
);

Transmisor trans(clk,reset,start_tx,s_tick,out_data,tx_done,TX);


endmodule
