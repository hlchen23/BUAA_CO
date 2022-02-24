`timescale 1ns / 1ps
`include "MACRO.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:29:41 12/02/2020 
// Design Name: 
// Module Name:    IF_ID 
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
module IF_ID(
    input [31:0] Instr_IF,
    input [31:0] PC8_Out_IF,
    input [31:0] PC_IF,
	 input BD_IF,
	 input Stall,
	 input ActivateCP0,
	 input CoolCP0,
	 input AdEL_F,
    output reg[31:0] Instr_ID,
    output reg[31:0] PC8_Out_ID,
    output reg[31:0] PC_ID,
	 output reg BD_ID,
	 input Clk,
	 input Rst,
	 input[4:0] ExcCode_True_F,
	 output reg[4:0] ExcCode_D
    );
	always@(posedge Clk)begin
		if(Rst||ActivateCP0||CoolCP0)begin
			Instr_ID <= 0;
			PC8_Out_ID <= 0;
			PC_ID <= 0;
			BD_ID <= 0;
			ExcCode_D <= 5'b0;
		end
		else if(~Stall)begin
			if(AdEL_F)begin
				Instr_ID <= 0;
				PC8_Out_ID <= PC8_Out_IF;
				PC_ID <= PC_IF;
				BD_ID <= BD_IF;
				ExcCode_D <= ExcCode_True_F;
			end
			else begin
				Instr_ID <= Instr_IF;
				PC8_Out_ID <= PC8_Out_IF;
				PC_ID <= PC_IF;
				BD_ID <= BD_IF;
				ExcCode_D <= ExcCode_True_F;
			end
		end
	end

endmodule
