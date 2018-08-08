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
    
    input RX,
    input [31:0] inLatch,
    input [31:0] inPC,
    input [31:0] inFRData,
    input [31:0] inMemData,
        
    output led0,
    output [31:0] outDebugAddress,
    output [6:0] outControlLatchMux,
    output loadProgram,
    output [31:0] addressInstrucctionProgram,
    output [31:0] InstructionProgram,
    output write_instruction,
    output TX,
    output stopPC_debug 
);
    
// Registros --- Maquina Transmisora 

reg state_mode;
reg [31:0]	sendData;
reg 		stopPC;
reg 		tx_start;
//-----------------Maquina de Estados-----------------------------
reg [2:0] 	state_send;

localparam [2:0] send_init = 3'b000;
localparam [2:0] send_PC = 3'b001;
localparam [2:0] send_Rmem = 3'b010;
localparam [2:0] send_Mem = 3'b011;
localparam [2:0] send_Latch = 3'b100;
localparam [2:0] send_waitFinish = 3'b101;
localparam [2:0] send_Finish = 3'b110;

localparam [3:0] cant_senal_fetch = 4'd2;
localparam [3:0] cant_senal_decode = 4'd6;
localparam [3:0] cant_senal_execute = 4'd6;
localparam [3:0] cant_senal_memory = 4'd4;
localparam [3:0] cant_senal_wb = 4'd2;

reg [2:0] state_prev;


// Registros --- Maquina Receptora de instrucciones 
reg [31:0]	rx_direccion;
reg [31:0]  rx_Instruccion;
reg         mode;
reg         WriteRead;

//--------------------- Maquina de estado-------------------------
reg [1:0] state_rx;

localparam rx_init = 2'b00;
localparam rx_program = 2'b01;
localparam rx_stop = 2'b10;

//---------------------------------------------------------------

// Cables
wire [31:0] outRegData;
wire [31:0] outMemData;
wire rx_done;
wire write;
wire [31:0] dout;
wire tx_dataready;

// Registros
reg debug;
reg debug_mode;
reg [31:0] address;
reg [3:0]senal;
reg [2:0]etapa;
reg load_program;

assign stopPC_debug =stopPC;
assign InstructionProgram	=	rx_Instruccion;
assign addressInstrucctionProgram	=	rx_direccion;
assign write_instruction   =   WriteRead;
assign loadProgram = load_program;
assign outDebugAddress = address;
assign outControlLatchMux = {etapa,senal};
assign led0 = debug_mode;


// Instancia de UART
Top_UART uart(
	.clk(clk),
	.reset(rst),
	
	.TX_start(tx_start),
	.UART_data(sendData),
	.RX(RX),
	.TX(TX),
	.write(write),
	.dout(dout),
	.tx_dataready(tx_dataready)
);


// Maquina de estado de RX
always @ (posedge clk, posedge rst)
begin
	if(rst)
		begin
		state_rx <= rx_init;
		debug_mode <= 1'b0;
		rx_direccion <= 32'hffffffff;
		load_program = 1'b1;
		WriteRead <= 1'b0;
		end
	else
		begin
			case(state_rx)
            
            rx_init:
                begin
                    if(write)
                        begin    
                            debug_mode <= dout[0]; 
                            state_rx <= rx_program;
                            load_program = 1'b1;
                        end
                end
			
			rx_program:
				begin	
					if(write)
						begin	
							if(dout == 32'b01111111111111111111111111111110)// Instruccion de Halt para terminar el cargado de memoria		
								begin
								    WriteRead <= 1'b0;
								    load_program = 1'b0;
									state_rx <= rx_stop;
								end
                            else
                                begin
                                    WriteRead <= 1'b1;
                                    state_rx <= rx_program;
                                    rx_direccion <= rx_direccion+1;
                                    rx_Instruccion <= dout;
                                end
						end
					else
					   begin
					       WriteRead <= 1'b0;
					       state_rx <= rx_program;
                       end
				end
				
            rx_stop:
                begin
                    load_program = 1'b0;
                    WriteRead <= 1'b0;
                    state_rx <= rx_stop;
                end	
			endcase
		end

end


/* maquina de estado del TX 
* send_init: Estado inicial. Solo se pasa si no se esta recibiendo datos por la interfaz RX.
* send_Rmem: 
*/
always @(posedge clk,posedge rst)
begin
	if(rst)
		begin
			stopPC<=1'b1;
			tx_start<=1'b0;
			state_send <= send_init;
			state_prev <= send_Rmem;
			etapa <= 3'b0;
			senal <= 4'b0;
			sendData <= 32'b0;
		end
	else
		begin
		case(state_send)
            send_init:
                begin
                    if(state_rx == rx_stop)
                        begin
                            if (!debug_mode) // Envio todo al final del programa
                                begin
                                    if (inPC == rx_direccion + 32'd4) // Finalizo el programa
                                        begin
                                            stopPC <= 1'b1;
                                            state_send<=send_PC;                               
                                        end
                                    else
                                        begin
                                            stopPC <= 1'b0;
                                            state_send<=send_init;
                                        end
                                end
                           else // Envio todo despues de cada instruccion
                               begin
                                    stopPC<=1'b1; 
                                    if (!RX)
                                        begin 
                                            state_send <= send_PC;
                                        end
                                    else
                                        state_send <= send_init;
                               end     
                        end
                    else
                        state_send <= send_init; 
                end
                
            send_PC:
                begin
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
                    if (address == 32'd19)  
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
                    tx_start<=1'b0;
                    if(tx_dataready == 1'b1)
                        begin
                            state_send <= state_prev;
                        end
                end
                
            send_Finish:
                begin
                    stopPC<=1'b0;
                    tx_start<=1'b0;
                    if (debug_mode)
                        begin
                            state_send <= send_init;
                        end
                    else
                        state_send <= send_Finish;
                end
            
            endcase
        end
end
    
endmodule
