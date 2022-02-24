`timescale 1ns / 1ps
`include "MACRO.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:31:47 12/02/2020 
// Design Name: 
// Module Name:    MEM_WB 
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
module MEM_WB(
    input [31:0] Instr_MEM,
    input [31:0] ALU_Out_MEM,
	 input [31:0] MDU_Out_MEM,
    input [31:0] DM_Out_MEM,
	 input [31:0] CP0_Out_MEM,
    input [31:0] PC8_Out_MEM,
	 input [31:0] PC_MEM,
    input [4:0] Rx_MEM,
	 output reg[31:0] Instr_WB,
    output reg[31:0] ALU_Out_WB,
	 output reg[31:0] MDU_Out_WB,
    output reg[31:0] DM_Out_WB,
	 output reg[31:0] CP0_Out_WB,
    output reg[31:0] PC8_Out_WB,
	 output reg[31:0] PC_WB,
    output reg[4:0] Rx_WB,
    input Clk,
	 input Rst
    );
	always@(posedge Clk)begin
		if(Rst)begin
			Instr_WB <= 0;
			ALU_Out_WB <= 0;
			MDU_Out_WB <= 0;
			DM_Out_WB <= 0;
			CP0_Out_WB <= 0;
			PC8_Out_WB <= 0;
			PC_WB <= 0;
			Rx_WB <= 0;
		end
		else begin
			Instr_WB <= Instr_MEM;
			ALU_Out_WB <= ALU_Out_MEM;
			MDU_Out_WB <= MDU_Out_MEM;
			DM_Out_WB <= DM_Out_MEM;
			CP0_Out_WB <= CP0_Out_MEM;
			PC8_Out_WB <= PC8_Out_MEM;
			PC_WB <= PC_MEM;
			Rx_WB <= Rx_MEM;
		end
	end

endmodule
