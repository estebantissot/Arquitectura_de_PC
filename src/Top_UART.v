`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Materia:         Arquitectura de Computadoras
// Alumnos:         Tissot Esteban
//			        Manero Matias
// 
// Create Date:     15:50:01 03/01/2018 
// Design Name: 
// Module Name:     Top_UART 
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

module Top_UART(
		input  clk,
		input  reset,
		
		// INPUT
		input  TX_start,
		input  [31:0] UART_data,
		input  RX,
        // OUTPUT
        //output rx_done,
		output MIPS_enable,
		output TX,
		output [31:0] rx_address,
		output write,
		output [31:0] dout,
		output tx_dataready
);

wire s_tick;//,transmitir;
wire [7:0] rx_data;
wire [7:0] tx_data;
wire tx_start;

reg [31:0] data;
reg send;
reg reg_tx_start;

wire [31:0] send_data;
wire init_tx;

wire tx_done, rx_done, new_result;

BRG baud(clk,s_tick);

Receptor rec(
    .clk(clk),
    .reset(reset),
    // INPUT
    .rx(RX),
    .s_tick(s_tick),
    // OUTPUT
    .rx_done_tick(rx_done),
    .dout(rx_data)
);

Interfaz_Rx rx(
    .clk(clk),
    .reset(reset),
    // INPUT
    .start(rx_done),
    .din(rx_data),
    // OUTPUT
    .MIPS_enable(MIPS_enable),
    .go(write),
    .rx_address(rx_address),
    .dout(dout)
);


Interfaz_Tx tx(
    .clk(clk),
    .reset(reset),
    // INTPUT
    .in_data(UART_data), //(dout),
    .new_result(TX_start),// (write),
    .tx_done(tx_done),
    // OUTPUT
    .out_data(tx_data),
    .tx_start(tx_start),
    .data_done(tx_dataready)
);

Transmisor trans(
    .clk(clk),
    .reset(reset),
    // INPUT
    .tx_start(tx_start),
    .s_tick(s_tick),
    .din(tx_data),
    // OUTPUT
    .tx_done_tick(tx_done),
    .tx(TX)
);



/*assign send_data = data;
assign init_tx = reg_tx_start;

always @(posedge clk, posedge reset)
begin
    if (reset)
        begin
         send <= 1'b0;
         data <= 32'b0;
         reg_tx_start <= 1'b0;
        end
    else
        begin
            if(write)
            begin    
                data <= dout;//32'h01020304;
                send <= 1'b1;                      
            end
             
            if(!tx_dataready && send == 1'b1)
            begin
                reg_tx_start <= 1'b1;
                send <= 1'b0;
            end  
             else
                reg_tx_start <= 1'b0;  
        end
end
*/



/*

reg [1:0] state_rx;
reg [1:0] state_tx;

reg [7:0] data1;
reg [7:0] data2;
reg [7:0] data3;
reg [7:0] data4;
reg [7:0] reg_tx_data;
reg reg_tx_start;

localparam [1:0] rx_data1 = 2'b00;
localparam [1:0] rx_data2 = 2'b01;
localparam [1:0] rx_data3 = 2'b10;
localparam [1:0] rx_data4 = 2'b11;

localparam [1:0] tx_idle = 2'b00;
localparam [1:0] tx_data2 = 2'b01;
localparam [1:0] tx_data3 = 2'b10;
localparam [1:0] tx_data4 = 2'b11;

assign tx_data = reg_tx_data;
assign tx_start = reg_tx_start;


Receptor rec(
    .clk(clk),
    .reset(reset),
    .rx(RX),
    .s_tick(s_tick),
    .rx_done_tick(rx_done),
    .dout(rx_data)
);

always @(posedge clk, posedge reset)
begin
    if (reset)
        begin
            state_rx <= rx_data1;
            state_tx <= tx_idle;
            reg_tx_start <= 1'b0;
            data1 <= 8'b0;
            data2 <= 8'b0;
            data3 <= 8'b0;
            data4 <= 8'b0;
            
        end
    else
        begin
            if(rx_done)
            begin
                case (state_rx)
                    rx_data1:
                        begin
                            data1 <=  rx_data;
                            state_rx <= rx_data2;
                        end
                    rx_data2:
                        begin
                            data2 <=  rx_data;
                             state_rx <= rx_data3;
                        end
                    rx_data3:
                        begin
                            data3 <=  rx_data;
                            state_rx <= rx_data4;
                        end
                    rx_data4:
                        begin
                            data4 <=  rx_data;
                            state_rx <= rx_data1;
                            reg_tx_data <= data1;//8'd49;
                            state_tx <= tx_data2;
                            reg_tx_start <= 1'b1;
                        end
                 endcase
             end
             
             if(tx_done)
                 begin
                     case (state_tx)
                         tx_data2:
                             begin
                                 reg_tx_data <=  data2;//8'd50;
                                 state_tx <= tx_data3;
                                 reg_tx_start <= 1'b1;
                             end
                         tx_data3:
                             begin
                                 reg_tx_data <=  data3;//8'd51;
                                  state_tx <= tx_data4;
                                  reg_tx_start <= 1'b1;
                             end
                         tx_data4:
                             begin
                                 reg_tx_data <= data4;//8'd52;;
                                 state_tx <= tx_idle;
                                 reg_tx_start <= 1'b1;
                             end
                         tx_idle:
                             begin
                                reg_tx_start <= 1'b0;
                                reg_tx_data <= 8'b0;
                            end
                      endcase
                  end
        end
end

Transmisor trans(
    .clk(clk),
    .reset(reset),
    .tx_start(tx_start),
    .s_tick(s_tick),
    .din(tx_data),
    .tx_done_tick(tx_done),
    .tx(TX)
);
*/



endmodule
