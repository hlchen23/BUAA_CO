`timescale 1ns / 1ps
`include "MACRO.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:26:55 12/02/2020 
// Design Name: 
// Module Name:    COMP 
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
module COMP(
	input[31:0] COMP1,
	input[31:0] COMP2,
	output Zero,
	output Large,
	output Little,
	output Equal
    );
assign Zero = (COMP1==COMP2)? 1'b1: 1'b0;
assign Large = ($signed(COMP1)>0)? 1'b1: 1'b0;
assign Little = ($signed(COMP1)<0)? 1'b1: 1'b0;
assign Equal = ($signed(COMP1)==0)? 1'b1: 1'b0;
endmodule
