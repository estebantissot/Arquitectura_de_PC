`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Materia: Arquitectura de Computadoras
// Alumnos: Tissot Esteban
//			Manero Matias
// 
// Create Date:    15:50:01 03/01/2018 
// Design Name: 
// Module Name:    MuxLatch 
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


module MuxLatch(
    input clk,
    input rst,
    input [6:0]inControl,

	//-- Modulo Instruction Fetch --
	input [31:0]	ifetch0_outNextInstructionAddress, //ifetch0:outInstructionAddress -> idecode0:inInstructionAddress
	input [31:0]	ifetch0_outInstruction, 			//ifetch0:outInstruction -> idecode0:inInstruction

	//-- Modulo Instruction Decode --
	input [4:0]		idecode0_outWB, 	//idecode0:outWB -> execute0:inWB
	input [1:0]		idecode0_outMEM, 	//idecode0:outMEM -> execute0:inMEM
	input [5:0]		idecode0_outEXE, 	//idecode0:outEXE -> execute0:inEXE
	input [31:0]	idecode0_outNextInstructionAddress, //idecode0:outInstructionAddress -> execute0:inInstructionAddress
	input [31:0]	idecode0_outRegA, 	//idecode0:outRegA -> execute0:inRegA
	input [31:0]	idecode0_outRegB, 	//idecode0:outRegB -> execute0:inRegB
	input [31:0]	idecode0_outInstruction_ls, //idecode0:outInstruction_ls -> execute0:inInstruction_ls
	input [4:0]		idecode0_out_rs, //idecode0:out_rs -> execute0:in_rs
	input [4:0]		idecode0_out_rt, //idecode0:out_rt -> execute0:in_rt
	input [4:0]		idecode0_outRT_rd, //idecode0:outRT_rd -> execute0:inRT_rd
	input    		idecode0_outPC_write,
	input    		idecode0_outIF_ID_write,

	//-- Modulo Execute --
	input [4:0]		execute0_outWB, 		//execute0:outWB -> memaccess0:inWB
	input [1:0]		execute0_outMEM, 		//execute0:outMEM -> memacces0:inMEM
	input           execute0_outJL,
	input [31:0]    execute0_outNextInstructionAddress,
	input [31:0]	execute0_outPCJump, 	//execute0:outPCJump -> memaccess0:inPCJump
	input [31:0]	execute0_outALUResult,//execute0:outALUResult -> memaccess0:inALUResult
	//input 			execute0_outALUZero, 	//execute0:outALUZero -> memaccess0:inALUZero
	input [31:0] 	execute0_outRegB, 		//execute0:outRegB -> memaccess0:inRegB
	input [4:0]		execute0_outRegF_wreg, //execute0:outRegF_wreg -> memaccess0:inRegF_wreg
	input           execute0_outPCSel,

	//-- Modulo MemoryAccess --
	input [4:0]		memaccess0_outWB, 			//memaccess0:outWB -> wb0:inWB
	input [31:0]	memaccess0_outRegF_wd, 	//memaccess0:outRegF_wd -> wb0:inRegF_wd
	input [31:0] 	memaccess0_outALUResult, //memaccess0:outALUResult -> wb0:inALUResult & MEM_AluResult(execute stage)
	input [4:0]		memaccess0_outRegF_wreg, //memaccess0:outRegF_wreg -> idecode0:inRegF_wreg

	//-- Modulo Write Back --
	input 			wb0_outRegF_wr, // wb0:outRegF_wr -> idecode0:inRegF_wr & WB_regF_wr (execute stage)
	input [31:0]	wb0_outRegF_wd, // wb0:outRegF_wd -> idecode0:inRegF_wd & WB_regF_wd(execute stage)
	    
    output [31:0] 	out_data
    );
    
// Registros
reg [31:0] data;

//Asignaciones
assign out_data = data;

// Logica del mux
always @(posedge clk,posedge rst)
begin
	if(rst)
		begin
			data <= 32'b0;
		end
	else
		begin
			case(inControl)
	            // Send the Latchs of the state Fetch 
	            7'b000_0000:
	              	data <= ifetch0_outNextInstructionAddress;
	            7'b000_0001:
	            	data <= ifetch0_outInstruction;
	                      
	            // Send the Latchs of the state Decode
	            7'b001_0000:
	            	data <= {8'b0 , {2'b0,idecode0_outEXE} , {6'b0,idecode0_outMEM} , {3'b0,idecode0_outWB}};
	            7'b001_0001:
	            	data <= idecode0_outNextInstructionAddress;
	            7'b001_0010:
	            	data <= idecode0_outRegA;
	            7'b001_0011:
	            	data <= idecode0_outRegB;
				7'b001_0100:
	            	data <= idecode0_outInstruction_ls;        
	            7'b001_0101:
	            	data <= {{3'b0,idecode0_out_rs} , {3'b0,idecode0_out_rt} , {3'b0,idecode0_outRT_rd} , {6'b0,idecode0_outPC_write,idecode0_outIF_ID_write}}; 	                    
                    
	            // Send the Latchs of the state Execute   
	      		7'b010_0000:
	            	data <= {8'b0 , 8'b0 , {6'b0,execute0_outMEM} , {3'b0,execute0_outWB}};
	            7'b010_0001:
	               data <= execute0_outNextInstructionAddress;
	            7'b010_0010:
	            	data <= execute0_outPCJump;
	            7'b010_0011:
	            	data <= execute0_outALUResult;
	            7'b010_0100:
	            	data <= execute0_outRegB;
				7'b010_0101:
	            	data <= { 8'b0, {7'b0,execute0_outJL} , {7'b0,execute0_outPCSel} , {3'b0,execute0_outRegF_wreg}}; //execute0_outALUZero
	             
	            // Send the Latchs of the state Memory
	            7'b011_0000:
	            	data <= {8'b0 , 8'b0 , 8'b0 , {3'b0,memaccess0_outWB}};
	            7'b011_0001:
	            	data <= memaccess0_outRegF_wd;
	            7'b011_0010:
	            	data <= memaccess0_outALUResult;
            	7'b011_0011:		
	            	data <= {8'b0 , 8'b0 , {8'b0} , {3'b0,memaccess0_outRegF_wreg}};
	            	
	            // Send the Latchs of the state Wite Back
	            7'b100_0000:
	            	data <= wb0_outRegF_wd;
	            7'b100_0001:
	            	data <= {8'b0 , 8'b0 , 8'b0 ,{7'b0,wb0_outRegF_wr}};
	      
	            default:
	               data <= 32'bZ;
	        endcase
        end
end
    
endmodule





