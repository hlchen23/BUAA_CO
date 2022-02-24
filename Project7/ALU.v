`timescale 1ns / 1ps
`include "MACRO.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:17:13 12/02/2020 
// Design Name: 
// Module Name:    ALU 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ALU(
    input[31:0] ALU_A,
    input[31:0] ALU_B,
    input[4:0] ALUOp,
    output Zero,//×÷·Ï
    output[31:0] ALU_Out,
	 output AddOverFlow,
	 output SubOverFlow
    );
	 wire[31:0] SLT_Out;
	 wire[31:0] SLTU_Out;
	 wire[31:0] LUI_Out;
	 
	 assign SLT_Out = ($signed(ALU_A)<$signed(ALU_B))? 32'b1: 32'b0;
	 assign SLTU_Out = ($unsigned(ALU_A)<$unsigned(ALU_B))? 32'b1: 32'b0;
	 assign LUI_Out = {ALU_B[15:0],16'b0};
	 
	 
	 wire[63:0] temp_add;
	 wire[63:0] temp_sub;
	 assign temp_add = {ALU_A[31],ALU_A} + {ALU_B[31],ALU_B};
	 assign temp_sub = {ALU_A[31],ALU_A} - {ALU_B[31],ALU_B};
	 assign AddOverFlow = (temp_add[32]!=temp_add[31])? 1'b1: 1'b0;
	 assign SubOverFlow = (temp_sub[32]!=temp_sub[31])? 1'b1: 1'b0;
	 
assign Zero = (ALU_A == ALU_B)? 1: 0;
assign ALU_Out = (ALUOp == `ADD_)? (ALU_A + ALU_B):
                (ALUOp == `SUB_)? (ALU_A - ALU_B):
                (ALUOp == `OR_)? (ALU_A | ALU_B): 
					 (ALUOp == `AND_)? (ALU_A & ALU_B):
					 (ALUOp == `XOR_)? (ALU_A ^ ALU_B):
					 (ALUOp == `NOR_)? (~(ALU_A | ALU_B)):
					 (ALUOp == `SLT_)? SLT_Out:
					 (ALUOp == `SLTU_)? SLTU_Out:
					 (ALUOp == `LUI_)? LUI_Out:
					 (ALUOp == `SLL_)? (ALU_B << ALU_A[4:0]):
					 (ALUOp == `SRL_)? (ALU_B >> ALU_A[4:0]):
					 (ALUOp == `SRA_)? ($signed($signed(ALU_B) >>> ALU_A[4:0])):
					                                     ALU_A + ALU_B;

endmodule
