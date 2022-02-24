`timescale 1ns / 1ps
`include "MACRO.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:21:45 12/02/2020 
// Design Name: 
// Module Name:    IFU 
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
module IFU(
	input[15:0] Imm16,
	input[25:0] Imm26,
	input[31:0] Reg,
	input[1:0] NPCOp,
	input Rst,
	input Clk,
	output[31:0] Instr,
	output[31:0] PC8_Out,
	output reg[31:0] PC
    );
	
	wire[31:0] N_PC;
	NPC NPC1(
			.PC(PC),
			.Imm16(Imm16),
			.Imm26(Imm26),
			.Reg(Reg),
			.NPCOp(NPCOp),
			.N_PC(N_PC),
			.PC8_Out(PC8_Out)
			);

always@(posedge Clk)begin
	if (Rst) begin
		PC <= 32'h00003000;
	end
	else begin
		PC <= N_PC;
	end
end

	IM IM(.IM_Addr(PC),.Instr(Instr));


endmodule

