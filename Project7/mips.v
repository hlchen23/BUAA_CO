`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:44:51 12/18/2020 
// Design Name: 
// Module Name:    mips 
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
module mips(
	input clk,
	input reset,
	input interrupt,//外部中断信号
	output[31:0] addr//宏观PC
    );
	 
	 wire[31:0] CPU_Addr;
	 wire[31:0] CPU_WD;
	 wire[31:0] CPU_RD;
	 wire CPU_total_WeEn;
	 wire[31:0] DEV_Addr;
	 wire[31:0] DEV_WD;
	 wire[31:0] DM_RD;
	 wire[31:0] Timer0_RD;
	 wire[31:0] Timer1_RD;
	 wire We_DM;
	 wire We_Timer0;
	 wire We_Timer1;
	 
	 wire IRQ_Timer0;
	 wire IRQ_Timer1;
	 wire[5:0] HWInt;
	 assign HWInt = {3'b0,interrupt,IRQ_Timer1,IRQ_Timer0};
	CPU CPU(
		.clk(clk),
		.reset(reset),
		.CPU_Addr(CPU_Addr),
		.CPU_WD(CPU_WD),
		.CPU_RD(CPU_RD),
		.CPU_total_WeEn(CPU_total_WeEn),
		.DEV_Addr(DEV_Addr),
		.DEV_WD(DEV_WD),
		.DM_RD(DM_RD),
		.We_DM(We_DM),
		.HWInt(HWInt),
		.MacroPC(addr)
		);
	 
	Bridge Bridge(
		.CPU_Addr(CPU_Addr),
		.CPU_WD(CPU_WD),
		.CPU_RD(CPU_RD),
		.CPU_total_WeEn(CPU_total_WeEn),
		.DEV_Addr(DEV_Addr),
		.DEV_WD(DEV_WD),
		.DM_RD(DM_RD),
		.Timer0_RD(Timer0_RD),
		.Timer1_RD(Timer1_RD),
		.We_DM(We_DM),
		.We_Timer0(We_Timer0),
		.We_Timer1(We_Timer1)
		);
	 
	TC Timer0(
		.clk(clk),
		.reset(reset),
		.Addr(DEV_Addr),
		.WE(We_Timer0),
		.Din(DEV_WD),
		.Dout(Timer0_RD),
		.IRQ(IRQ_Timer0)
    );
	 
	 TC Timer1(
		.clk(clk),
		.reset(reset),
		.Addr(DEV_Addr),
		.WE(We_Timer1),
		.Din(DEV_WD),
		.Dout(Timer1_RD),
		.IRQ(IRQ_Timer1)
    );
	 
endmodule
