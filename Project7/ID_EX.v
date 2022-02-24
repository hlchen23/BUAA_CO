`timescale 1ns / 1ps
`include "MACRO.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:30:24 12/02/2020 
// Design Name: 
// Module Name:    ID_EX 
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
module ID_EX(
	 input Stall,
	 input ActivateCP0,
	 input CoolCP0,
	 input RI,
	 input [31:0] Instr_ID,
    input [31:0] RD1_ID,
    input [31:0] RD2_ID,
    input [31:0] EXT_Out_ID,
    input [31:0] PC8_Out_ID,
    input [31:0] PC_ID,
    input [4:0] Rx_ID,
	 input BD_ID,
	 output reg[31:0] Instr_EX,
    output reg[31:0] RD1_EX,
    output reg[31:0] RD2_EX,
    output reg[31:0] EXT_Out_EX,
    output reg[31:0] PC8_Out_EX,
    output reg[31:0] PC_EX,
    output reg[4:0] Rx_EX,
	 output reg BD_EX,
    input Clk,
	 input Rst,
	 input[4:0] ExcCode_True_D,
	 output reg[4:0] ExcCode_E
    );
	always@(posedge Clk)begin
		if((Rst)||(Stall)||(ActivateCP0)||(CoolCP0))begin
			Instr_EX <= 0;
			RD1_EX <= 0;
			RD2_EX <= 0;
			EXT_Out_EX <= 0;
			PC8_Out_EX <= 0;
			PC_EX <= 0;
			Rx_EX <= 0;
			BD_EX <= 0;
			ExcCode_E <= 5'b0;
		end
		else if(RI)begin
			Instr_EX <= 0;
			RD1_EX <= RD1_ID;
			RD2_EX <= RD2_ID;
			EXT_Out_EX <= EXT_Out_ID;
			PC8_Out_EX <= PC8_Out_ID;
			PC_EX <= PC_ID;
			Rx_EX <= Rx_ID;
			BD_EX <= BD_ID;
			ExcCode_E <= ExcCode_True_D;
		end
		else begin
			Instr_EX <= Instr_ID;
			RD1_EX <= RD1_ID;
			RD2_EX <= RD2_ID;
			EXT_Out_EX <= EXT_Out_ID;
			PC8_Out_EX <= PC8_Out_ID;
			PC_EX <= PC_ID;
			Rx_EX <= Rx_ID;
			BD_EX <= BD_ID;
			ExcCode_E <= ExcCode_True_D;
		end
	end

endmodule
