`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:43:08 10/18/2017 
// Design Name: 
// Module Name:    Interfaz_Tx 
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
module Interfaz_Tx(
	//INPUT
	input clk,
	input reset,
	input wire [31:0] in_data,
	input wire new_result,
	input tx_done,
	// OUTPUT
	output wire [7:0] out_data,
	output wire tx_start,
	output data_done
);

	reg [7:0] data_out;
	reg [2:0]state;
	reg start;
	//debug
	reg dataDone;
	reg [31:0] inData;
	
	localparam idle = 2'b00;
	localparam send_value = 2'b01;
	localparam send_valor = 2'b10;
	
	assign out_data = data_out;
	assign tx_start = start;
	assign data_done = dataDone;

	//integer bit_msb;
	integer bit_lsb;
	
	always @ (posedge clk, posedge reset)
	if(reset)
	begin
		state <=  idle;
		start <= 1'b0;
		bit_lsb <= 24;
		//bit_msb <= 31;
		inData <= 32'b0;
		dataDone  <=  1'b0;
		data_out  <=  8'b0;
	end
	else
	begin
		case(state)
			idle:
				begin
				    dataDone <= 1'b0;
					if(new_result)
						begin
							start <= 1'b0;
							inData <= in_data;
							bit_lsb <= 24;
							state <= send_value;
						end
					else
						state <= idle;
				end
			send_value:
				begin
					//if(tx_done)
					//	begin
							data_out <= inData[31:24]+48;
							inData <= inData << 8;
							start <= 1'b1;
							//bit_msb <= bit_msb-8;
							bit_lsb <= bit_lsb-8;
							state <= send_valor;
					//	end
				end
			send_valor:
				begin
					if(tx_done)
						begin
						data_out <= inData[31:24]+8'd48;
                        inData <= inData << 8;
							if(bit_lsb < 0)
								begin
									dataDone <= 1'b1;
									start <= 1'b0;
                                    bit_lsb <= 24;
									state <=idle;
								end
							else
							begin
                                start <= 1'b1;
                                bit_lsb <= bit_lsb-8;
							end
						end
					else
						begin
							start <= 1'b0;
							state <= send_valor;
						end
				end
			endcase
end


endmodule
