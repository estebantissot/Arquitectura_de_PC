`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Materia: Arquitectura de Computadoras
// Alumnos: Tissot Esteban
//				Manero Matias
// 
// Create Date:    15:48:31 03/01/2018 
// Design Name: 
// Module Name:    top_level 
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
module top_level(
    input clk,
    input reset,
	input UART_TXD_IN,
	output UART_RXD_OUT,
	output led0
	//output led1
);

//assign UART_RXD_OUT = UART_TXD_IN;

// Cables

//-- Modulo Instruction Fetch --
wire [31:0]	ifetch0_outInstructionAddress; //ifetch0:outInstructionAddress -> idecode0:inInstructionAddress
wire [31:0]	ifetch0_outInstruction; 			//ifetch0:outInstruction -> idecode0:inInstruction

//-- Modulo Instruction Decode --
wire [4:0]	idecode0_outWB; 	//idecode0:outWB -> execute0:inWB
wire [2:0]	idecode0_outMEM; 	//idecode0:outMEM -> execute0:inMEM
wire [3:0]	idecode0_outEXE; 	//idecode0:outEXE -> execute0:inEXE
wire [31:0]	idecode0_outInstructionAddress; //idecode0:outInstructionAddress -> execute0:inInstructionAddress
wire [31:0]	idecode0_outRegA; 	//idecode0:outRegA -> execute0:inRegA
wire [31:0]	idecode0_outRegB; 	//idecode0:outRegB -> execute0:inRegB
wire [31:0]	idecode0_outInstruction_ls; //idecode0:outInstruction_ls -> execute0:inInstruction_ls
wire [4:0]	idecode0_out_rs; //idecode0:out_rs -> execute0:in_rs
wire [4:0]	idecode0_out_rt; //idecode0:out_rt -> execute0:in_rt
wire [4:0]	idecode0_outRT_rd; //idecode0:outRT_rd -> execute0:inRT_rd
wire        idecode0_outPC_write;
wire        idecode0_outIF_ID_write;
wire [5:0]  idecode0_outInmmediateOpcode;
wire [31:0] idecode0_outPCJump;
wire        idecode0_jump;
//-- Modulo Execute --
wire [4:0]	execute0_outWB; 		//execute0:outWB -> memaccess0:inWB
wire [1:0]	execute0_outMEM; 		//execute0:outMEM -> memacces0:inMEM
wire [31:0]	execute0_outPCBranch; 	//execute0:outPCJump -> memaccess0:inPCJump
wire [31:0]	execute0_outALUResult;//execute0:outALUResult -> memaccess0:inALUResult
wire 			execute0_outALUZero; 	//execute0:outALUZero -> memaccess0:inALUZero
wire [31:0] execute0_outRegB; 		//execute0:outRegB -> memaccess0:inRegB
wire [4:0]	execute0_outRegF_wreg; //execute0:outRegF_wreg -> memaccess0:inRegF_wreg

//-- Modulo MemoryAccess --
wire [4:0]	memaccess0_outWB; 			//memaccess0:outWB -> wb0:inWB
wire 		memaccess0_outPCSel; 		//memaccess0:outPCSel -> ifetch0:inPCSel
wire [31:0]	memaccess0_outPCJump; 	//memaccess0:outPCJump -> ifetch0:inPCJump
wire [31:0] memaccess0_outRegF_wd; 	//memaccess0:outRegF_wd -> wb0:inRegF_wd
wire [31:0] memaccess0_outALUResult; //memaccess0:outALUResult -> wb0:inALUResult & MEM_AluResult(execute stage)
wire [4:0]	memaccess0_outRegF_wreg; //memaccess0:outRegF_wreg -> idecode0:inRegF_wreg

//-- Modulo Write Back --
wire 		wb0_outRegF_wr; // wb0:outRegF_wr -> idecode0:inRegF_wr & WB_regF_wr (execute stage)
wire [31:0]	wb0_outRegF_wd; // wb0:outRegF_wd -> idecode0:inRegF_wd & WB_regF_wd(execute stage)

//debug
wire stop_debug;
wire loadProgram;
wire [31:0] muxLatch_outData;
wire [6:0]  ControlLatchMux;

wire tx_start;
wire MIPS_enable;
wire Debug_on;
wire [31:0] FRData;
wire [31:0] MemData;
wire [31:0] DebugAddress;
wire wr_program_instruction;
wire [31:0] program_instruction;
wire [31:0] addressInstrucctionProgram;
//wire [31:0] rx_address;
wire rst;
wire [31:0]jump_branch;

assign rst = (!reset);
assign jump_branch= (memaccess0_outPCSel)? execute0_outPCBranch:idecode0_outPCJump;
// Instancias
// Instancia del modulo Instruction Fetch
InstructionFetch ifetch0(
	//Clock and Reset Signals
	.clk(clk),
	.rst(rst),
		
	//debug
	.loadProgram(loadProgram),
	.addressInstrucctionProgram(addressInstrucctionProgram),
    .data_instruction(program_instruction),
    .wr_instruction(wr_program_instruction),
	.stop_debug(stop_debug),

	//Input Signals
	.inPC_write(idecode0_outPC_write),
	.inIF_ID_write(idecode0_outIF_ID_write),
	.inPCSel(memaccess0_outPCSel|idecode0_jump),
	.inPCJump(jump_branch),
	
	//Output Signals
	.outInstructionAddress(ifetch0_outInstructionAddress),
	.outInstruction(ifetch0_outInstruction)
);


// Instancia del modulo Instruction Decode
InstructionDecode idecode0(
	//Clock and Reset Signals
	.clk(clk),
	.rst(rst),
		
	//Input Signals
	.inRegF_wr(wb0_outRegF_wr),
	.inInstructionAddress(ifetch0_outInstructionAddress),
	.inInstruction(ifetch0_outInstruction),
	.inRegF_wreg(memaccess0_outRegF_wreg),
	.inRegF_wd(wb0_outRegF_wd),
	.EXE_mem_read(idecode0_outMEM[1]),
	.EXE_rd(idecode0_out_rt), //rt (registro destino en la instruccion load).
	.Debug_on(Debug_on),
	.Debug_read_reg(DebugAddress[4:0]),

	//Branch
	.ID_flush(memaccess0_outPCSel),
	
	//Stop Debug
	.stop_debug(stop_debug),
	//Output Signals
	.outWB(idecode0_outWB),
	.outMEM(idecode0_outMEM),
	.outEXE(idecode0_outEXE),
	.outInstructionAddress(idecode0_outInstructionAddress),
	.outRegA(idecode0_outRegA),
	.outRegB(idecode0_outRegB),
	.outInstruction_ls(idecode0_outInstruction_ls),
	.out_rs(idecode0_out_rs),
	.out_rt(idecode0_out_rt),
	.outRT_rd(idecode0_outRT_rd),
	.outPC_write(idecode0_outPC_write),
    .outIF_ID_write(idecode0_outIF_ID_write),
    .out_regDebug(FRData),
    .outInmmediateOpcode(idecode0_outInmmediateOpcode),
    
    .outAddress_jump(idecode0_outPCJump),
    .jump_take(idecode0_jump)
	
);
	
// Instancia del modulo Execute
Execute execute0(
	//Clock and Reset Signals
	.clk(clk),
	.rst(rst),

	//Input Signals
	.inWB(idecode0_outWB),
	.inMEM(idecode0_outMEM),
	.inEXE(idecode0_outEXE),
	.inInstructionAddress(idecode0_outInstructionAddress),
	.MEM_AluResult(execute0_outALUResult),
	.WB_regF_wd(wb0_outRegF_wd),
	.inRegA(idecode0_outRegA),
	.inRegB(idecode0_outRegB),
	.inInstruction_ls(idecode0_outInstruction_ls),
	.in_rs(idecode0_out_rs),
	.in_rt(idecode0_out_rt),
	.inRT_rd(idecode0_outRT_rd),
	.MEM_rd(execute0_outRegF_wreg), 
	.MEM_regF_wr(execute0_outWB[1]),
	.WB_rd(memaccess0_outRegF_wreg),
	.WB_regF_wr(wb0_outRegF_wr),
    .inInmmediateOpcode(idecode0_outInmmediateOpcode),
    
    //Stop Debug
     .stop_debug(stop_debug),
    
	//Output Signals
	.outWB(execute0_outWB),
	.outMEM(execute0_outMEM),

	//Branch
   	.outPCSel(memaccess0_outPCSel),
	.outPCJump(execute0_outPCBranch),
	
	.outALUResult(execute0_outALUResult),
	.outALUZero(execute0_outALUZero),
	.outRegB(execute0_outRegB),
	.outRegF_wreg(execute0_outRegF_wreg)
);

// Instancia del modulo memAccess
MemoryAccess memaccess0(
	//Clock and Reset Signals
	.clk(clk),
	.rst(rst),

	//Input Signals
	.inWB(execute0_outWB),
	.inMEM(execute0_outMEM),
	//.inPCJump(execute0_outPCJump),
	.inALUResult(execute0_outALUResult),
	.inALUZero(execute0_outALUZero),
	.inRegB(execute0_outRegB),
	.inRegF_wreg(execute0_outRegF_wreg),
	.Debug_on(Debug_on),
	.Debug_read_mem(DebugAddress),
    
    //Stop Debug
    .stop_debug(stop_debug),
	//Output Signals    
	.outWB(memaccess0_outWB),
	.outRegF_wd(memaccess0_outRegF_wd),
	.outALUResult(memaccess0_outALUResult),
	.outRegF_wreg(memaccess0_outRegF_wreg),
	.outMemDebug(MemData)
);


// Instancia del modulo Write Back
WriteBack wb0(
	//Input Signals
	.inWB(memaccess0_outWB),
	.inRegF_wd(memaccess0_outRegF_wd),
	.inALUResult(memaccess0_outALUResult),
	
	//Output Signals
	.outRegF_wr(wb0_outRegF_wr),
	.outRegF_wd(wb0_outRegF_wd)
);

// Instancia del Mux para enviar los Latch de cada etapa
MuxLatch ml0(
    .clk(clk),
    .rst(rst),
    .inControl(ControlLatchMux),
    
    //-- Modulo Instruction Fetch --
    .ifetch0_outInstructionAddress(ifetch0_outInstructionAddress), 
    .ifetch0_outInstruction(ifetch0_outInstruction), 			
    
    //-- Modulo Instruction Decode --
    .idecode0_outWB(idecode0_outWB), 	
    .idecode0_outMEM(idecode0_outMEM), 	
    .idecode0_outEXE(idecode0_outEXE), 	
    .idecode0_outInstructionAddress(idecode0_outInstructionAddress), 
    .idecode0_outRegA(idecode0_outRegA),
    .idecode0_outRegB(idecode0_outRegB),
    .idecode0_outInstruction_ls(idecode0_outInstruction_ls),
    .idecode0_out_rs(idecode0_out_rs), 
    .idecode0_out_rt(idecode0_out_rt), 
    .idecode0_outRT_rd(idecode0_outRT_rd), 
    .idecode0_outPC_write(idecode0_outPC_write),
    .idecode0_outIF_ID_write(idecode0_outIF_ID_write),
    
    //-- Modulo Execute --
    .execute0_outWB(execute0_outWB), 		
    .execute0_outMEM(execute0_outMEM), 	
    .execute0_outPCJump(execute0_outPCBranch), 	
    .execute0_outALUResult(execute0_outALUResult),
    .execute0_outALUZero(execute0_outALUZero), 	
    .execute0_outRegB(execute0_outRegB), 		
    .execute0_outRegF_wreg(execute0_outRegF_wreg), 
    
    //-- Modulo MemoryAccess --
    .memaccess0_outWB(memaccess0_outWB),
    .memaccess0_outPCSel(memaccess0_outPCSel), 			 	
    .memaccess0_outRegF_wd(memaccess0_outRegF_wd), 	
    .memaccess0_outALUResult(memaccess0_outALUResult), 
    .memaccess0_outRegF_wreg(memaccess0_outRegF_wreg), 
    
    //-- Modulo Write Back --
    .wb0_outRegF_wr(wb0_outRegF_wr), 
    .wb0_outRegF_wd(wb0_outRegF_wd), 
    
    .out_data(muxLatch_outData)
    );


// Instancia de la unidad de Debugging
DebugUnit debug(

	.clk(clk),
    .rst(rst),
    // INPUT
    .RX(UART_TXD_IN),
    .inLatch(muxLatch_outData),
    .inPC(ifetch0_outInstructionAddress),
    .inFRData(FRData),
    .inMemData(MemData),
    
    // OUTPUT
    .led0(led0),
    //.led1(led1),
    
    .out_debug_on(Debug_on),
    .outDebugAddress(DebugAddress),
    .loadProgram(loadProgram),
    .addressInstrucctionProgram(addressInstrucctionProgram),
    .InstructionProgram(program_instruction),
    .write_instruction(wr_program_instruction),
    //.rx_address(rx_address),
    .TX(UART_RXD_OUT), 
    .stopPC_debug(stop_debug),
    .outControlLatchMux(ControlLatchMux)

);

endmodule
