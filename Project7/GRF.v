`timescale 1ns / 1ps
`include "MACRO.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:23:52 12/02/2020 
// Design Name: 
// Module Name:    GRF 
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
module GRF(
	input[4:0] A1,
	input[4:0] A2,
	input[4:0] A3,
	input[31:0] WrReg,
	input[31:0] PC,
	output[31:0] RD1,
	output[31:0] RD2,
	input GRF_En,
	input Clk,
	input Rst
    );
	reg[31:0] Reg[0:31];
	
	always@(posedge Clk)begin
		if (Rst)begin
			Reg[0] <= 0;
			Reg[1] <= 0;
			Reg[2] <= 0;
			Reg[3] <= 0;
			Reg[4] <= 0;
			Reg[5] <= 0;
			Reg[6] <= 0;
			Reg[7] <= 0;
			Reg[8] <= 0;
			Reg[9] <= 0;
			Reg[10] <= 0;
			Reg[11] <= 0;
			Reg[12] <= 0;
			Reg[13] <= 0;
			Reg[14] <= 0;
			Reg[15] <= 0;
			Reg[16] <= 0;
			Reg[17] <= 0;
			Reg[18] <= 0;
			Reg[19] <= 0;
			Reg[20] <= 0;
			Reg[21] <= 0;
			Reg[22] <= 0;
			Reg[23] <= 0;
			Reg[24] <= 0;
			Reg[25] <= 0;
			Reg[26] <= 0;
			Reg[27] <= 0;
			Reg[28] <= 0;
			Reg[29] <= 0;
			Reg[30] <= 0;
			Reg[31] <= 0;
		end
		else begin
			if ((GRF_En)&&(A3!=5'b00000))begin
				Reg[A3] <= WrReg;
				$display("%d@%h: $%d <= %h", $time, PC, A3, WrReg);
				//$display("@%h: $%d <= %h", PC, A3, WrReg);
			end
		end
	end
	
	assign RD1 = (A1==5'b00000)? 32'b0: Reg[A1];
	assign RD2 = (A2==5'b00000)? 32'b0: Reg[A2];

endmodule
