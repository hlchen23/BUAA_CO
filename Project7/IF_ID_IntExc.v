`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:54:40 12/17/2020 
// Design Name: 
// Module Name:    IF_ID_IntExc 
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
module IF_ID_IntExc(
	input[4:0] ExcCode_True_F,
	output reg[4:0] ExcCode_D,
	input Clk,
	input Rst,
	input ActivateCP0,
	input CoolCP0
    );
	always@(posedge Clk)begin
		if(Rst||ActivateCP0||CoolCP0)begin
			ExcCode_D <= 5'b0;
		end
		else begin
			ExcCode_D <= ExcCode_True_F;
		end
	end

endmodule
