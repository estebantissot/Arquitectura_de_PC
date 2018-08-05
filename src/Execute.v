`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Materia: Arquitectura de Computadoras
// Alumnos: Tissot Esteban
//				Manero Matias
// 
// Create Date:    16:05:25 03/01/2018 
// Design Name: 
// Module Name:    Execute 
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
module Execute(
//Clock and Reset Signals
    input clk,
    input rst,
	 
//Input Signals
    input [4:0] 	inWB,
    input [2:0] 	inMEM,
    input [3:0] 	inEXE,
    input [31:0] 	inInstructionAddress,
    input [31:0] 	MEM_AluResult,
    input [31:0]    WB_regF_wd,
    input [31:0] 	inRegA,
    input [31:0] 	inRegB,
    input [31:0] 	inInstruction_ls,
    input [4:0] 	in_rs,
    input [4:0] 	in_rt,
    input [4:0] 	inRT_rd,
    input [4:0]     MEM_rd,     
    input           MEM_regF_wr,
    input [4:0]     WB_rd,     
    input           WB_regF_wr,
	input [5:0]		inInmmediateOpcode,
	
	//debug
	input           stop_debug,				 
//Output Signals
    output [4:0] 	outWB,
    output [2:0] 	outMEM,
    output 			outPCSel,
    output [31:0]   outPCJump,
    output [31:0]   outALUResult,
    output 			outALUZero,
    output [31:0]   outRegB,
    output [4:0] 	outRegF_wreg
    );

// Registros
    reg [4:0] 	WB;
    reg [2:0]   MEM;
    reg [31:0]  ALUResult;
    reg 	   ALUZero;
    reg [31:0] RegB;
    reg [4:0]  RegF_wreg;
	reg [4:0]  wreg;
	reg [31:0] regB_ALU;
	reg [31:0] regA_ALU;
    reg        PCSel;
    // Cables
    wire [3:0] 	ALUControl;
    wire [31:0] ALU_A;
    wire [31:0] ALU_B;
    wire [31:0] alu_result;
    wire 		alu_zero;
    wire [1:0]  control_muxA; //control mux de inAluA 
    wire [1:0]  control_muxB; //control mux de inAluB.
    wire [5:0]  Opcode;
    wire        shif_variable;
    
// Asignaciones
assign outWB = WB;
assign outMEM = MEM;
assign outRegF_wreg = RegF_wreg;
assign outALUResult = ALUResult;
assign outALUZero = ALUZero;
assign outRegB = RegB;
assign ALU_B = regB_ALU;
assign ALU_A = regA_ALU;

//Instancia de "ALU"
ALU #(.bits(32)) alu0 (
	.A(ALU_A),
	.B(ALU_B),
	.select(ALUControl),
	.Zero(alu_zero),
	.C(alu_result)
);

// Asignaciones
assign outPCJump = inInstruction_ls + inInstructionAddress;
assign outPCSel = PCSel;// (inMEM[2] && (inRegA==inRegB))? 1'b1:1'b0;
assign Opcode = (inEXE[2:1] == 2'b11)? inInmmediateOpcode:inInstruction_ls[5:0];
assign shif_variable= ((inEXE[2:1] == 2'b10) && (inInstruction_ls[10:6] != 5'b0))? 1'b1:1'b0;
//Instancia de "ALUControl"
ALUControl alu_contol0 (
	.inALUop(inEXE[2:1]),
	.inInstructionOpcode(Opcode),
	.outALUControl(ALUControl)
);

//Instancia de "ForwardingUnit"
ForwardingUnit forwarding_unit0 (
	.rst(rst),
	.rs(in_rs),
	.rt(in_rt),
	.MEM_rd(MEM_rd),
	.MEM_regF_wr(MEM_regF_wr),
	.WB_rd(WB_rd),
	.WB_regF_wr(WB_regF_wr),
	.out_control_muxA(control_muxA),
	.out_control_muxB(control_muxB)
);


always @(negedge clk, posedge rst)
begin
	if(rst)
		begin
			WB <= 5'b00000;
			MEM <= 3'b010;
			RegF_wreg <= 5'bZZZZZ;
			ALUResult <= 32'b0;
			ALUZero <= 1'b0;
			RegB <= 32'b0;
			
		end
	else
		begin
		  if(!stop_debug)
		  begin
                WB <= inWB;
                MEM <= inMEM;
                RegF_wreg <= wreg;
                ALUResult <= alu_result;
                ALUZero <= alu_zero;
                RegB <= inRegB;
		  end
	end
end

always @(*)
	begin
		if(rst)
			begin
			    regA_ALU <= 32'b0;
				wreg <= 0;
				regB_ALU<= 0;
				PCSel <= 0;
			end
		else
			begin
			    if(inMEM[2] && (inRegA==inRegB))
			         PCSel=1'b1;
			    else
			         PCSel=1'b0;
			
				//Jump <= ((inInstruction_ls << 2) + inInstructionAddress);
				casez(inEXE)
					
					4'b0???: wreg <= in_rt;    //registro rt de la instruccion Load
					4'b1???: wreg <= inRT_rd;
					default:
						begin
							wreg <= inRT_rd;
						end
				endcase
				// MUX A
				casez({shif_variable,control_muxA})
				    3'b000: regA_ALU <= inRegA;
				    3'b001: regA_ALU <= WB_regF_wd;
				    3'b010: regA_ALU <= MEM_AluResult;
				    3'b1??: regA_ALU <= inInstruction_ls[10:6];
				    default:regA_ALU <= inRegA;
				endcase
				// MUX B
				case({inEXE[0],control_muxB}) //control_muxB
					3'b000: regB_ALU <= inRegB;
					3'b001: regB_ALU <= WB_regF_wd;
					3'b010: regB_ALU <= MEM_AluResult;
					3'b100: regB_ALU <= inInstruction_ls;  
					default:
						begin
								regB_ALU <= inRegB;
						end
				endcase
			end
	end
endmodule
