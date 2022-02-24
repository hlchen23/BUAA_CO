`timescale 1ns / 1ps
`include "MACRO.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:19:17 12/02/2020 
// Design Name: 
// Module Name:    NPC 
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
module NPC(
	input Stall,
	input[31:0] PC,
	input[15:0] Imm16,
	input[25:0] Imm26,
	input[31:0] Reg,
	input[31:0] EPC,
	input[2:0] NPCOp,//来源于D级
	input ActivateCP0,//from E
	input CoolCP0,//from E
	output [31:0] N_PC,
	output[31:0] PC8_Out
    );
	assign PC8_Out = PC + 8;
	wire[31:0] PC4;
	assign PC4 = PC + 4;
	wire[31:0] PCminus4;
	assign PCminus4 = PC - 4;
	wire[2:0] NPCOp_NEW = (ActivateCP0)? 3'b100: 
	                 (CoolCP0)? 3'b101:
						                    NPCOp;
	assign N_PC =  (NPCOp_NEW == 3'b100)? 32'h0000_4180:
						(NPCOp_NEW == 3'b101)? EPC:
						(Stall==1'b1)? PC:
						(NPCOp_NEW == `IMM16)?(PCminus4 + 32'd4 + {{14{Imm16[15]}},Imm16,{2{1'b0}}}):
						(NPCOp_NEW == `IMM26)?({PCminus4[31:28],Imm26,{2{1'b0}}})://差一个周期
						(NPCOp_NEW == `REG)? Reg:
													(PC + 4);
	
endmodule
