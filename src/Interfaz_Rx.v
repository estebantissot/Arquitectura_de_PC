`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Materia:         Arquitectura de Computadoras
// Alumnos:         Tissot Esteban
//			        Manero Matias
// 
// Create Date:     15:50:01 03/01/2018 
// Design Name: 
// Module Name:     Interfaz_Rx 
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

module Interfaz_Rx(
	
	input 	clk,
	input 	reset,
	
	input 	start,
	input 	[7:0] din,

	output 	go,
	//output  [31:0] rx_address,
	output	[31:0] dout
);

// Registros
reg [7:0] 	num;
reg [31:0]	Data;		
reg [1:0]	state_byte;
reg 		ready;
//reg [31:0]  new_address;
    
// Parametros Locales
localparam [1:0] first_byte     = 2'b00;
localparam [1:0] second_byte    = 2'b01;
localparam [1:0] third_byte     = 2'b10;
localparam [1:0] fourth_byte    = 2'b11;

// Asignaciones
assign dout	=	Data;
assign go	=	ready;
//assign rx_address = new_address;

// Logica del modulo
always@(posedge clk, posedge reset)
	begin
		if(reset)
			begin
				Data	<=	32'b0;
				ready	<=	1'b0;	
				//new_address <= 32'b0;
				state_byte <= first_byte;
			end
		else
			begin
                if(start)
                    begin
                        case(state_byte)
                            first_byte:
                                begin
                                    Data[31:24] <=  din;// - 8'd48;
                                    state_byte <= second_byte;
                                    ready	<=	1'b0;
                                end
                            second_byte:
                                begin
                                    Data[23:16] <=  din;//- 8'd48;
                                    state_byte <= third_byte;
                                    ready	<=	1'b0;                                    
                                end
                            third_byte:
                                begin
                                    Data[15:8] <=  din; //- 8'd48;
                                    state_byte <= fourth_byte;
                                    ready	<=	1'b0;                                    
                                end
                            fourth_byte:
                                begin
                                    Data[7:0] <=  din;// - 8'd48;
                                    state_byte <= first_byte;
                                    ready	<=	1'b1;                                    
                                end                               
                        endcase
                    end
                else
                    begin
                        ready	<=	1'b0;
                    end			
				end
	end		
	
endmodule
