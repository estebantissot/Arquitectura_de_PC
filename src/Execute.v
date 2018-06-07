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
    input [1:0] 	inWB,
    input [2:0] 	inMEM,
    input [3:0] 	inEXE,
    input [31:0] 	inInstructionAddress,
    input [31:0] 	MEM_AluResult,
    input [31:0]    	WB_regF_wd,
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
	 
//Output Signals
    output [1:0] 	outWB,
    output [2:0] 	outMEM,
    output [31:0] outPCJump,
    output [31:0] outALUResult,
    output 			outALUZero,
    output [31:0] outRegB,
    output [4:0] 	outRegF_wreg
    );

// Registros
    reg [1:0] 	WB;
    reg [2:0] 	MEM;
    reg [31:0] PCJump;
	reg [31:0] Jump;
    reg [31:0] ALUResult;
    reg 		ALUZero;
    reg [31:0] RegB;
    reg [4:0] 	RegF_wreg;
	reg [4:0] 	wreg;
	reg [31:0] regB_ALU;
	reg [31:0] regA_ALU;

    // Cables
    wire [3:0] 	ALUControl;
    wire [31:0] ALU_A;
    wire [31:0] ALU_B;
    wire [31:0] alu_result;
    wire 			alu_zero;
    wire [1:0] control_muxA; //control mux de inAluA 
    wire [1:0] control_muxB; //control mux de inAluB.
    
    // Asignaciones
    assign outWB = WB;
    assign outMEM = MEM;
    assign outPCJump = PCJump;
    assign outRegF_wreg = RegF_wreg;
    assign outALUResult = ALUResult;
    assign outALUZero = ALUZero;
    assign outRegB = RegB;
    assign ALU_B = regB_ALU;
    assign ALU_A = regA_ALU;

//Instancia de "ALU"
ALU #(.bits(32)) alu0 (	
    .rst(rst),
	.A(ALU_A),
	.B(ALU_B),
	.select(ALUControl),
	.Zero(alu_zero),
	.C(alu_result)
);


//Instancia de "ALUControl"
ALUControl alu_contol0 (
	.rst(rst),
	.inALUop(inEXE[2:1]),
	.inInstructionOpcode(inInstruction_ls[5:0]),
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
			WB <= 2'b00;
			MEM <= 3'b010;
			PCJump <= 32'b0;
			RegF_wreg <= 5'bZZZZZ;
			ALUResult <= 32'b0;
			ALUZero <= 1'b0;
			RegB <= 32'b0;
		end
	else
		begin
			WB <= inWB;
			MEM <= inMEM;
			PCJump <= Jump; 
			RegF_wreg <= wreg;
			ALUResult <= alu_result;
			ALUZero <= alu_zero;
			RegB <= inRegB;
		end
end

always @(*)
	begin
		if(rst)
			begin
				wreg<=0;
				regB_ALU<=0;
			end
		else
			begin
				Jump <= ((inInstruction_ls << 2) + inInstructionAddress);
				casez(inEXE)
					
					4'b0???: wreg <= in_rt;    //registro rt de la instruccion Load
					4'b1???: wreg <= inRT_rd;
					default:
						begin
							wreg <= inRT_rd;
						end
				endcase
				// MUX A
				case(control_muxA)
				    2'b00: regA_ALU <= inRegA;
				    2'b01: regA_ALU <= WB_regF_wd;
				    2'b10: regA_ALU <= MEM_AluResult;
				    default:regA_ALU <= inRegA;
				endcase
				// MUX B
				casez({inEXE[0],control_muxB}) //control_muxB
					3'b000: regB_ALU <= inRegB;
					3'b001: regB_ALU <= WB_regF_wd;
					3'b010: regB_ALU <= MEM_AluResult;
					3'b100: regB_ALU <= inInstruction_ls; //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
					default:
						begin
								regB_ALU <= inRegB;
						end
				endcase
			end
	end
endmodule
