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

    input [31:0] PC,

    output [31:0] addressInstrucction,
    output [31:0] InstructionRecive,
    output write_read,
    output TX,
    output soft_rst,
    output stopPC_debug
    
    );
    
wire MIPS_enable;    

// Registros --- Maquina Transmisora 

reg mode;
reg state_mode;
reg [31:0]	sendData;
reg 		stopPC;
reg 		tx_start;
reg         WriteRead;
//-----------------Maquina de Estados-----------------------------
reg [1:0] 	state_send;
localparam [1:0] send_init = 2'b00;
localparam [1:0] send_Rmem = 2'b01;
localparam [1:0] send_waitFinish = 2'b10;
reg [1:0] state_prev;


// Registros --- Maquina Receptora de instrucciones 
reg [31:0]	rx_direccion;
reg [31:0]  rx_Instruccion;
//--------------------- Maquina de estado-------------------------
reg state_rx;
localparam rx_enviar = 1'b0;
localparam rx_stop = 1'b1;
//---------------------------------------------------------------



assign stopPC_debug =stopPC;
assign InstructionRecive	=	rx_Instruccion;
assign addressInstrucction	=	rx_direccion;

assign soft_rst = (rst || (!MIPS_enable));
assign write_read   =   WriteRead;

//assign tx_start = (Instruction==32'd19)? 1'b1:1'b0;


wire write;
wire [31:0] dout;
wire tx_dataready;

Top_UART uart(
	.clk(clk),
	.reset(rst),
	.TX_start(tx_start),
	.UART_data(sendData),
	.RX(RX),
	.MIPS_enable(MIPS_enable),
	.TX(TX),
	.write(write),
	.dout(dout),
	.tx_dataready(tx_dataready)
);


always @ (posedge clk, posedge rst)
begin
	if(rst)
		begin
		state_rx	=	rx_enviar;
		rx_direccion 	=	32'hffffffff;
		end
	else
		begin
			case(state_rx)
			rx_enviar:
				begin	
					if(write)
						begin
							rx_direccion  = rx_direccion+1;
							rx_Instruccion	= dout;

							WriteRead = 1'b1;
									
							if(dout == 32'h0 || rx_direccion == 32'hfffffff0)// Instruccion de Halt para terminar el cargado de memoria		
								begin
									state_rx = rx_stop;
								end
						end
					else
						WriteRead = 1'b0;
				end
			rx_stop:
				begin
					WriteRead<=1'b0;
				end
			endcase
		end

end



always @(posedge clk,posedge rst)
begin
	if(rst)
		begin
			stopPC<=1'b1;
			tx_start<=1'b1;
			state_send <= send_init;
		end
	else
		begin
		case(state_send)
		send_init:
			begin
				if(state_rx!=rx_stop)
					state_send<=send_init;
				else
					state_send<=send_Rmem;
			end
		send_Rmem:
			begin
				stopPC<=1'b1;
				sendData<=PC;
				tx_start<=1'b1;
				state_prev<=send_Rmem;
				state_send<=send_waitFinish;
			end
		send_waitFinish:
			begin
				stopPC<=1'b0;
				if(tx_dataready == 1'b0)
					begin
						state_send <= state_prev;
						tx_start<=1'b0;
					end
			end


		endcase


		end
	

end

    
endmodule
