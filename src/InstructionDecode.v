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
//Debug
    input           stop_debug,
        
//Output Signals
    output  [4:0]   outWB,
    output  [1:0] 	outMEM,
    output  [5:0] 	outEXE,
    output          outJL,
    output  [31:0]  outInstructionAddress,
    output  [31:0]  outRegA,
    output  [31:0]  outRegB,
    output  [31:0]  outInstruction_ls,
    output  [4:0] 	out_rs,
    output  [4:0] 	out_rt,
    output  [4:0] 	outRT_rd,
    output 	        outPC_write,
    output 	        outIF_ID_write,
    output  [31:0]  out_regDebug,
    output  [5:0]	outInmmediateOpcode,
    
    //Jump
    output [31:0]   outAddress_jump,
    output 			outJumpTake
    
    	
    );

//Registros
reg [4:0] 	WB;
reg [1:0] 	MEM;
reg [5:0] 	EXE;
reg [1:0]   JUMP;
reg [31:0] 	InstructionAddress;
reg signed [31:0]	Instruction_ls;
reg [4:0]   rs;
reg [4:0] 	rt;
reg [4:0] 	RT_rd;
reg [5:0]	InmmediateOpcode;
reg [31:0]  PCJump;
reg         PCSel;
reg [31:0]  address_jump;
//Cables
wire [14:0] outControl;
wire ControlMux;
wire write;

//Asignaciones
assign outWB = WB;
assign outMEM = MEM;
assign outEXE = EXE;
assign outInstructionAddress = InstructionAddress;
assign outInstruction_ls = (inInstruction[31:26]!=6'd8)? Instruction_ls>>16:Instruction_ls >>> 16;
assign out_rs = rs;
assign out_rt = rt;
assign outRT_rd = RT_rd;
assign outInmmediateOpcode	=	InmmediateOpcode; 
assign write = (Debug_on) ? 1'b0:inRegF_wr;

assign outJumpTake = JUMP[1];//(inInstruction[31:26] == 6'd2)? 1'b1:1'b0;
assign outAddress_jump= address_jump;
assign outJL = JUMP[0];

// Instancia de "Hazard Detection Unit"
HazardDetectionUnit hdu0(
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
	.inInstruction(inInstruction[31:26]),
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
	.stop_debug(stop_debug),
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
		WB = 5'd0;
		MEM = 3'd0;
		EXE = 6'd0;
		InstructionAddress = 32'd0;
		//RegA = 32'b0;
		//RegB = 32'b0;
		Instruction_ls = 32'd0;
		rs = 5'd0;
		rt = 5'd0;
		RT_rd = 5'd0;
	end
else // Escritura de todos los registros de salida
	begin
	   if(!stop_debug)
	   begin
           case (ControlMux & (!ID_flush))
                1'b0:
                begin
                    WB = 5'd0;
                    MEM = 2'd0;
                    EXE = 6'd0;
                end
                1'b1:
                begin
                    WB = outControl[4:0];
                    MEM = outControl[6:5];
                    EXE = outControl[12:7];
                    JUMP = outControl[14:13];
                end
            endcase
            
            if(JUMP[1])
            begin
                address_jump = {inInstructionAddress[31:28],inInstruction[25:0],2'b00};
            end
                
            else
                begin
                    address_jump = inInstructionAddress;
                end
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
end

endmodule
