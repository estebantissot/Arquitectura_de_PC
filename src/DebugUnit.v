`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Materia: Arquitectura de Computadoras
// Alumnos: Tissot Esteban
//			Manero Matias
// 
// Create Date:    15:50:01 03/01/2018 
// Design Name: 
// Module Name:    DebugUnit 
// Project Name: 	 TP4-PIPELINE 
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
    
    //input BTNC,
    (*dont_touch="true",mark_debug="true"*)input RX,
    input [31:0] inLatch,
    input [31:0] inPC,
    input [31:0] inFRData,
    input [31:0] inMemData,
        
    output        out_led2,    
    output        out_led1,
    output        out_led0,
    (*dont_touch="true",mark_debug="true"*)output        out_debug_on,
    output [31:0] outDebugAddress,
    
    output [31:0] rx_address,
    output [6:0] outControlLatchMux,
    output [31:0] addressInstrucction,
    output [31:0] InstructionRecive,
    output write_instruction,
    (*dont_touch="true",mark_debug="true"*)output TX,
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
(*dont_touch="true",mark_debug="true"*)reg [2:0] 	state_send;
localparam [2:0] send_init = 3'b000;
localparam [2:0] send_PC = 3'b001;
localparam [2:0] send_Rmem = 3'b010;
localparam [2:0] send_Mem = 3'b011;
localparam [2:0] send_Latch = 3'b100;
localparam [2:0] send_waitFinish = 3'b101;
localparam [2:0] send_Finish = 3'b110;

localparam [2:0] cant_senal_fetch = 3'd2;
localparam [2:0] cant_senal_decode = 3'd6;
localparam [2:0] cant_senal_execute = 3'd6;
localparam [2:0] cant_senal_memory = 3'd5;
localparam [2:0] cant_senal_wb = 3'd2;

reg [2:0] state_prev;


// Registros --- Maquina Receptora de instrucciones 
reg [31:0]	rx_direccion;
reg [31:0]  rx_Instruccion;
//--------------------- Maquina de estado-------------------------
reg state_rx;
localparam rx_enviar = 1'b0;
localparam rx_stop = 1'b1;
//---------------------------------------------------------------

// Cables
wire [31:0] outRegData;
wire [31:0] outMemData;
wire rx_done;

// Registros
reg debug;
reg [31:0] address;
reg [3:0]senal;
reg [2:0]etapa;
reg led;
(*dont_touch="true",mark_debug="true"*) reg reg_rx;

assign out_led0 = !state_send[0];
assign out_led1 = !state_send[1];
assign out_led2 = !state_send[2];
//assign out_led1 = SW0;
assign stopPC_debug =stopPC;
assign InstructionRecive	=	rx_Instruccion;
assign addressInstrucction	=	rx_direccion;

assign soft_rst = rst;//(rst || (!MIPS_enable));
assign write_instruction   =   WriteRead;

//assign tx_start = (Instruction==32'd19)? 1'b1:1'b0;

assign outDebugAddress = address;
assign outControlLatchMux = {etapa,senal};
assign out_debug_on = debug;


wire write;
wire [31:0] dout;
wire tx_dataready;

// Instancia de UART
Top_UART uart(
	.clk(clk),
	.reset(rst),
	
	.TX_start(tx_start),
	.UART_data(sendData),
	.RX(RX),
    .rx_address(rx_address),
    //.rx_done(rx_done),
	.MIPS_enable(MIPS_enable),
	.TX(TX),
	.write(write),
	.dout(dout),
	.tx_dataready(tx_dataready)
);

/*
// Maquina de estado de RX
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
*/


/* maquina de estado del TX 
* send_init: Estado inicial. Solo se pasa si no se esta recibiendo datos por la interfaz RX.
* send_Rmem: 
*/

always @(*)
begin
    reg_rx <= RX; 
end

always @(posedge clk,posedge rst)
begin
	if(rst)
		begin
			stopPC<=1'b1;
			tx_start<=1'b0;
			state_send <= send_init;
			etapa <= 3'b0;
			senal <= 4'b0;
			debug <= 1'b0;
			led <= 1'b0;
		end
	else
		begin
		case(state_send)
            send_init:
                begin
                  //led <= 1'b1;
                  if(inPC==32'd16)//(reg_rx == 1'b0)//if(write)//if(state_rx!=rx_stop)
                   begin
                        //led <= 1'b1;
                        state_send<=send_PC;
                        debug <= 1'b1;
                   end
                   else
                       //led <= 1'b1;
                        state_send<=send_init;
                end
                
            send_PC:
                begin
                    //led <= 1'b0;
                    stopPC<=1'b0; 
                    sendData<=inPC;
                    tx_start<=1'b1;
                    state_prev<=send_Rmem;
                    state_send<=send_waitFinish;
                    address <= 32'b00000000_00000000_00000000_00000000;
                end
               
            send_Rmem:
                begin
                    sendData <= inFRData;
                    tx_start<=1'b1;
                    if (address == 32'd31)
                        begin
                            address <= 32'b0;
                            state_prev<=send_Mem;
                            state_send<=send_waitFinish;
                        end
                    else
                        begin
                            address <= address+1;
                            state_prev<=send_Rmem;
                            state_send<=send_waitFinish;
                        end
            
                end
             
             send_Mem:
                begin
                    sendData <= inMemData;
                    tx_start<=1'b1;                    
                    if (address == 32'd19)  //if (address == 32'd20)
                        begin
                            address <= 32'b0;
                            state_prev<=send_Latch;
                            state_send<=send_waitFinish;
                        end
                    else
                        begin
                            address <= address+1;
                            state_prev<=send_Mem;
                            state_send<=send_waitFinish;
                        end
             end
             
             send_Latch:
                 begin
                    //sendData<=32'b01111111_00000110_00000111_00001000;
                    tx_start<=1'b1;
                    sendData <= inLatch;
                    state_send <= send_waitFinish;
                    
                    if(etapa == 3'b000)
                        begin
                            state_prev <= send_Latch;
                            if (senal == cant_senal_fetch-1)
                                begin
                                    etapa <= 3'b001;
                                    senal <= 4'b0;
                                end
                            else
                                senal <= senal+1;
                        end
                    if(etapa == 3'b001)
                        begin
                        state_prev <= send_Latch;
                        if (senal == cant_senal_decode-1)
                            begin
                                etapa <= 3'b010;
                                senal <= 4'b0;
                            end
                        else
                            senal <= senal+1;
                    end
                    if(etapa == 3'b010)
                        begin
                        state_prev <= send_Latch;
                            if (senal == cant_senal_execute-1)
                                begin
                                    etapa <= 3'b011;
                                    senal <= 4'b0;
                                end
                            else
                                senal <= senal+1;
                        end
                    if(etapa == 3'b011)
                        begin
                        state_prev <= send_Latch;
                            if (senal == cant_senal_memory-1)
                                begin
                                    etapa <= 3'b100;
                                    senal <= 4'b0;
                                end
                            else
                                senal <= senal+1;
                        end
                      if(etapa == 3'b100)
                          begin
                              if (senal == cant_senal_wb-1)
                                  begin
                                      etapa <= 3'b000;
                                      senal <= 4'b0;
                                      state_prev <= send_Finish;
                                  end
                              else
                                begin
                                  senal <= senal+1;
                                  state_prev <= send_Latch;
                                end
                          end
                
                 end
                
            send_waitFinish:
                begin
                    stopPC<=1'b1; 
                    tx_start<=1'b0;
                    if(tx_dataready == 1'b1)
                        begin
                            state_send <= state_prev;
                            //tx_start<=1'b0;
                        end
                end
                
            send_Finish:
                begin
                    debug <= 1'b0;
                    state_send <= send_init;
                   // led <= 1'b1;
                    // se debe esperar hasta que se quiera mandar todo de nuevo.
                end
            
            endcase
            end
	
end

    
endmodule
