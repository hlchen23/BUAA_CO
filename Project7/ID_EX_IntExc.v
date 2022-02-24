`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:05:17 12/17/2020 
// Design Name: 
// Module Name:    ID_EX_IntExc 
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
module ID_EX_IntExc(
	input[4:0] ExcCode_True_D,
	output reg[4:0] ExcCode_E,
	input Clk,
	input Rst,
	input ActivateCP0,
	input CoolCP0
    );
	always@(posedge Clk)begin
		if(Rst||ActivateCP0||CoolCP0)begin
			ExcCode_E <= 5'b00000;
		end
		else begin
			ExcCode_E <= ExcCode_True_D;
		end
	end
	
endmodule
