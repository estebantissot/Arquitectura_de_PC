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
    input CLK100MHZ,
    input CPU_RESETN,
	input UART_TXD_IN,
	output UART_RXD_OUT
    );

// Cables
wire clk;
wire rst;
wire RX;
wire TX;

assign clk = CLK100MHZ;
assign rst = CPU_RESETN;
assign RX = UART_TXD_IN;
assign TX = UART_RXD_OUT;


//-- Modulo Instruction Fetch --
wire [31:0]	ifetch0_outInstructionAddress; //ifetch0:outInstructionAddress -> idecode0:inInstructionAddress
wire [31:0]	ifetch0_outInstruction; 			//ifetch0:outInstruction -> idecode0:inInstruction

//-- Modulo Instruction Decode --
wire [1:0]	idecode0_outWB; 	//idecode0:outWB -> execute0:inWB
wire [2:0]	idecode0_outMEM; 	//idecode0:outMEM -> execute0:inMEM
wire [3:0]	idecode0_outEXE; 	//idecode0:outEXE -> execute0:inEXE
wire [31:0]	idecode0_outInstructionAddress; //idecode0:outInstructionAddress -> execute0:inInstructionAddress
wire [31:0]	idecode0_outRegA; 	//idecode0:outRegA -> execute0:inRegA
wire [31:0]	idecode0_outRegB; 	//idecode0:outRegB -> execute0:inRegB
wire [31:0]	idecode0_outInstruction_ls; //idecode0:outInstruction_ls -> execute0:inInstruction_ls
wire [4:0]	idecode0_outLD_rt; //idecode0:outLD_rt -> execute0:inLD_rt
wire [4:0]	idecode0_outRT_rd; //idecode0:outRT_rd -> execute0:inRT_rd

//-- Modulo Execute --
wire [1:0]	execute0_outWB; 		//execute0:outWB -> memaccess0:inWB
wire [2:0]	execute0_outMEM; 		//execute0:outMEM -> memacces0:inMEM
wire [31:0]	execute0_outPCJump; 	//execute0:outPCJump -> memaccess0:inPCJump
wire [31:0]	execute0_outALUResult;//execute0:outALUResult -> memaccess0:inALUResult
wire 			execute0_outALUZero; 	//execute0:outALUZero -> memaccess0:inALUZero
wire [31:0] execute0_outRegB; 		//execute0:outRegB -> memaccess0:inRegB
wire [4:0]	execute0_outRegF_wreg; //execute0:outRegF_wreg -> memaccess0:inRegF_wreg

//-- Modulo MemoryAccess --
wire [1:0]	memaccess0_outWB; 			//memaccess0:outWB -> wb0:inWB
wire 			memaccess0_outPCSel; 		//memaccess0:outPCSel -> ifetch0:inPCSel
wire [31:0]	memaccess0_outPCJump; 	//memaccess0:outPCJump -> ifetch0:inPCJump
wire [31:0] memaccess0_outRegF_wd; 	//memaccess0:outRegF_wd -> wb0:inRegF_wd
wire [31:0] memaccess0_outALUResult; //memaccess0:outALUResult -> wb0:inALUResult
wire [4:0]	memaccess0_outRegF_wreg; //memaccess0:outRegF_wreg -> idecode0:inRegF_wreg

//-- Modulo Write Back --
wire 			wb0_outRegF_wr; // wb0:outRegF_wr -> idecode0:inRegF_wr
wire [31:0]	wb0_outRegF_wd; // wb0:outRegF_wd -> idecode0:inRegF_wd



wire soft_rst; 
wire tx_start;
wire MIPS_enable;

assign soft_rst = rst;
assign tx_start = (ifetch0_outInstructionAddress==32'd19)? 1'b1:1'b0;

Top_UART uart(.clk(clk),.reset(rst),.TX_start(tx_start),.UART_data(execute0_outALUResult),.RX(RX),.MIPS_enable(MIPS_enable),.TX(TX));




// Instancias
// Instancia del modulo Instruction Fetch
InstructionFetch ifetch0(
	//Clock and Reset Signals
	.clk(clk),
	.rst(soft_rst),
	
	//Input Signals
	.inPCSel(memaccess0_outPCSel),
	.inPCJump(memaccess0_outPCJump),
	
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

	//Output Signals
	.outWB(idecode0_outWB),
	.outMEM(idecode0_outMEM),
	.outEXE(idecode0_outEXE),
	.outInstructionAddress(idecode0_outInstructionAddress),
	.outRegA(idecode0_outRegA),
	.outRegB(idecode0_outRegB),
	.outInstruction_ls(idecode0_outInstruction_ls),
	.outLD_rt(idecode0_outLD_rt),
	.outRT_rd(idecode0_outRT_rd)
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
	.inRegA(idecode0_outRegA),
	.inRegB(idecode0_outRegB),
	.inInstruction_ls(idecode0_outInstruction_ls),
	.inLD_rt(idecode0_outLD_rt),
	.inRT_rd(idecode0_outRT_rd),

	//Output Signals
	.outWB(execute0_outWB),
	.outMEM(execute0_outMEM),
	.outPCJump(execute0_outPCJump),
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
	.inPCJump(execute0_outPCJump),
	.inALUResult(execute0_outALUResult),
	.inALUZero(execute0_outALUZero),
	.inRegB(execute0_outRegB),
	.inRegF_wreg(execute0_outRegF_wreg),

	//Output Signals    
	.outWB(memaccess0_outWB),
	.outPCSel(memaccess0_outPCSel),
	.outPCJump(memaccess0_outPCJump),
	.outRegF_wd(memaccess0_outRegF_wd),
	.outALUResult(memaccess0_outALUResult),
	.outRegF_wreg(memaccess0_outRegF_wreg)
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


endmodule
