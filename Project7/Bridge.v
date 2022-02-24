`timescale 1ns / 1ps
`define DM_Addr_start 32'h0000_0000		
`define DM_Addr_end   32'h0000_2FFF		
`define IM_Addr_start 32'h0000_3000		
`define IM_Addr_end  32'h0000_4FFF		
`define Timer0_Addr_start  32'h0000_7f00		
`define Timer0_Addr_end    32'h0000_7f0B		
`define Timer1_Addr_start  32'h0000_7f10		
`define Timer1_Addr_end    32'h0000_7f1B	
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:47:14 12/17/2020 
// Design Name: 
// Module Name:    Bridge 
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
module Bridge(
	input[31:0] CPU_Addr,
	//input[3:0] CPU_BE, 对Timer整字操作，暂时不需要
	input[31:0] CPU_WD,
	output[31:0] CPU_RD,
	input CPU_total_WeEn,
	output[31:0] DEV_Addr,
	output[31:0] DEV_WD,
	input[31:0] DM_RD,
	input[31:0] Timer0_RD,
	input[31:0] Timer1_RD,
	output We_DM,
	output We_Timer0,
	output We_Timer1
    );
	
	//传递读
	assign CPU_RD = ((CPU_Addr>=`DM_Addr_start)&&(CPU_Addr<=`DM_Addr_end))? DM_RD:
						((CPU_Addr>=`Timer0_Addr_start)&&(CPU_Addr<=`Timer0_Addr_end))? Timer0_RD:
						((CPU_Addr>=`Timer1_Addr_start)&&(CPU_Addr<=`Timer1_Addr_end))? Timer1_RD:
																															32'b0;
	//传递写
	assign We_DM = ((CPU_total_WeEn)&&((CPU_Addr>=`DM_Addr_start)&&(CPU_Addr<=`DM_Addr_end)));
	assign We_Timer0 = ((CPU_total_WeEn)&&((CPU_Addr>=`Timer0_Addr_start)&&(CPU_Addr<=`Timer0_Addr_end)));
	assign We_Timer1 = ((CPU_total_WeEn)&&((CPU_Addr>=`Timer1_Addr_start)&&(CPU_Addr<=`Timer1_Addr_end)));
	
	assign DEV_WD = CPU_WD;
	assign DEV_Addr = CPU_Addr;
	
endmodule
