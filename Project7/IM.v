`timescale 1ns / 1ps
`include "MACRO.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:20:51 12/02/2020 
// Design Name: 
// Module Name:    IM 
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
module IM(
	input[31:0] IM_Addr,
	output[31:0] Instr
    );
	 reg[31:0] IM_Reg[0:4095];
	 initial begin
		$readmemh("code.txt",IM_Reg);
		$readmemh("code_handler.txt", IM_Reg, 1120, 2047);
	 end
	assign Instr = IM_Reg[IM_Addr[13:2]-12'hc00];//◊¢“‚¿©»›¡À

endmodule
