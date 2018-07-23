`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Materia: Arquitectura de Computadoras
// Alumnos: Tissot Esteban
//				Manero Matias
// 
// Create Date:    16:00:12 03/01/2018 
// Design Name: 
// Module Name:    InstructionDecode 
// Project Name: 	 MIPS 
// Description:   
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module InstructionDecode(
//Clock and Reset Signals
    input clk,
    input rst,
	 
//Input Signals
    input           inRegF_wr,
    input [31:0] 	inInstructionAddress,
    input [31:0] 	inInstruction,
    input [4:0] 	inRegF_wreg,
    input [31:0] 	inRegF_wd,
    input           EXE_mem_read,
    input [4:0]     EXE_rd,
    input           Debug_on,
    input [4:0]     Debug_read_reg,
	 
// Branch
	input 			ID_flush,

//Output Signals
    output  [1:0]   outWB,
    output  [2:0] 	outMEM,
    output  [3:0] 	outEXE,
    output  [31:0]  outInstructionAddress,
    output  [31:0]  outRegA,
    output  [31:0]  outRegB,
    output  [31:0]  outInstruction_ls,
    output  [4:0] 	out_rs,
    output  [4:0] 	out_rt,
    output  [4:0] 	outRT_rd,
    output 	        outPC_write,
    output 	        outIF_ID_write,
    output          outFlush,
    output  [31:0]  out_regDebug,
    output  [6:0]	outInmmediateOpcode	 	
    );

//Registros
reg [1:0] 	WB;
reg [2:0] 	MEM;
reg [3:0] 	EXE;
reg [31:0] 	InstructionAddress;
//reg [31:0] 	RegA;
//reg [31:0] 	RegB;
reg signed [31:0]	Instruction_ls;
reg [4:0]   rs;
reg [4:0] 	rt;
reg [4:0] 	RT_rd;
reg [6:0]	InmmediateOpcode;
reg [31:0]  PCJump;
//Cables
//wire [31:0] RegF_outRegA;
//wire [31:0] RegF_outRegB;
wire [8:0] outControl;
wire ControlMux;
wire write;

//Asignaciones
assign outWB = WB;
assign outMEM = MEM;
assign outEXE = EXE;
assign outInstructionAddress = InstructionAddress;
//assign outRegA = RegF_outRegA;
//assign outRegB = RegF_outRegB;
assign outInstruction_ls = ((EXE[2:1]==2'b11) && (inInstruction[31:26]!=6'd8))? Instruction_ls>>16:Instruction_ls >>> 16;
assign out_rs = rs;
assign out_rt = rt;
assign outRT_rd = RT_rd;
assign outInmmediateOpcode	=	InmmediateOpcode;
 
assign write = (Debug_on) ? 1'b0:inRegF_wr;

// Instancia de "Hazard Detection Unit"
HazardDetectionUnit hdu0 (
	.rst(rst),
	.EXE_mem_read(EXE_mem_read),
	.EXE_rd(EXE_rd),
	.rs(inInstruction[25:21]),
	.rt(inInstruction[20:16]),
	.PCWrite(outPC_write),
	.IF_ID_write(outIF_ID_write),
	.ControlMux(ControlMux)
);

// Instancia de "Control Block"
ControlBlock ctrl0 (
	.rst(rst),
	.inInstruction(inInstruction),
	.outControl(outControl)
);

// Instancia de "File Register"
FileRegister regF0 (
	.clk(clk),
	.rst(rst),
	.write(write),
	.Debug_on(Debug_on),
	.read_reg1(inInstruction[25:21]),
	.read_reg2(inInstruction[20:16]),
	.read_regDebug(Debug_read_reg),
	.write_addr(inRegF_wreg),
	.write_data(inRegF_wd),
	.out_reg1(outRegA),
	.out_reg2(outRegB),
	.out_regDebug(out_regDebug)
);

//Equals unit
//assign Branch_equals = (outRegA==outRegB)?  1'b1:1'b0;

//Logica del Bloque
always @(negedge clk, posedge rst)
begin
if (rst)
	begin
		WB = 2'b00;
		MEM = 3'b010;
		EXE = 4'b0;
		InstructionAddress = 32'b0;
		//RegA = 32'b0;
		//RegB = 32'b0;
		Instruction_ls = 32'b0;
		rs = 5'b0;
		rt = 5'b0;
		RT_rd = 5'b0;
	end
else // Escritura de todos los registros de salida
	begin
	   case (ControlMux & (!ID_flush))
            1'b0:
            begin
                WB = 2'b0;
                MEM = 3'b0;
                EXE = 4'b0;
            end
            1'b1:
            begin
                WB = outControl[1:0];
                MEM = outControl[4:2];
                EXE = outControl[8:5];
            end
        endcase

		InstructionAddress = inInstructionAddress;
		InmmediateOpcode = inInstruction[31:26];
		//RegA = RegF_outRegA;
		//RegB = RegF_outRegB;
		//ID_flush = outPCSel;
		Instruction_ls = {inInstruction[15:0],16'b0};
		rs = inInstruction[25:21];
		rt = inInstruction[20:16];
		RT_rd = inInstruction[15:11];
	end
end

endmodule
