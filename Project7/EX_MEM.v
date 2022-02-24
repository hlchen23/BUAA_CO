`timescale 1ns / 1ps
`include "MACRO.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:31:10 12/02/2020 
// Design Name: 
// Module Name:    EX_MEM 
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
module EX_MEM(
	 input ActivateCP0,
    input [31:0] Instr_EX,
    input [31:0] ALU_Out_EX,
	 input [31:0] MDU_Out_EX,
	 input [31:0] CP0_Out_EX,
    input [31:0] RD2_EX,
    input [31:0] PC8_Out_EX,
    input [31:0] PC_EX,
    input [4:0] Rx_EX,
	 output reg[31:0] Instr_MEM,
    output reg[31:0] ALU_Out_MEM,
	 output reg[31:0] MDU_Out_MEM,
	 output reg[31:0] CP0_Out_MEM,
    output reg[31:0] RD2_MEM,
    output reg[31:0] PC8_Out_MEM,
    output reg[31:0] PC_MEM,
    output reg[4:0] Rx_MEM,
    input Clk,
	 input Rst
    );
	always@(posedge Clk)begin
		if(Rst||ActivateCP0)begin
			Instr_MEM <= 0;
			ALU_Out_MEM <= 0;
			MDU_Out_MEM <= 0;
			CP0_Out_MEM <= 0;
			RD2_MEM <= 0;
			PC8_Out_MEM <= 0;
			PC_MEM <= 0;
			Rx_MEM <= 0;
		end
		else begin
			Instr_MEM <= Instr_EX;
			ALU_Out_MEM <= ALU_Out_EX;
			MDU_Out_MEM <= MDU_Out_EX;
			CP0_Out_MEM <= CP0_Out_EX;
			RD2_MEM <= RD2_EX;
			PC8_Out_MEM <= PC8_Out_EX;
			PC_MEM <= PC_EX;
			Rx_MEM <= Rx_EX;
		end
	end

endmodule
