`timescale 1ns / 1ps
`include "MACRO.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:44:27 12/02/2020 
// Design Name: 
// Module Name:    Stall 
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
module Stall(
	input Busy,
	input Start,
	input[31:0] Instr_ID,
	input[4:0] Rs,
	input[4:0] Rt,
	input[4:0] Rx_EX,
	input[4:0] Rx_MEM,
	input[4:0] Rx_WB,
	input Tuse_RS0,
	input Tuse_RS1,
	input Tuse_RT0,
	input Tuse_RT1,
	input Tuse_RT2,
	input[1:0] Tnew_E,
	input[1:0] Tnew_M,
	input GRF_En_EX,
	input GRF_En_MEM,
	output Stall
    );
	wire Stall_RS0_E1;
	wire Stall_RS0_E2;
	wire Stall_RS0_M1;
	wire Stall_RS1_E2;
	wire Stall_RS;
	
	wire Stall_RT0_E1;
	wire Stall_RT0_E2;
	wire Stall_RT0_M1;
	wire Stall_RT1_E2;
	wire Stall_RT;
	
	wire Stall_MD;
	wire IsMD_ID;
	
	Ctrl Ctrl(
		.Instr(Instr_ID),
		.Zero(),
		.Large(),
		.Little(),
		.Equal(),
		.NPCOp(),
		.GRF_En(),
		.EXTOp(),
		.ALUOp(),
		.WDM_En(),
		.A3Sel(),
		.WrRegSel(),
		.ALU_AOp(),
		.ALU_BOp(),
		.EXT_Source(),
		.F_VALUE_WB_SEL(),
		.F_VALUE_MEM_SEL(),
		.Start(),
		.IsMD(IsMD_ID),
		.MDU_Out_Sel(),
		.HI_En(),
		.LO_En(),
		.BE_LOCATE_Op(),
		.DM_VALUE_Op(),
		.MDU_Sel()
		);
		
	assign Stall_RS0_E1 = Tuse_RS0 && (Tnew_E==2'b01) && (Rs==Rx_EX) && (Rx_EX!=5'b00000) && (GRF_En_EX);
	assign Stall_RS0_E2 = Tuse_RS0 && (Tnew_E==2'b10) && (Rs==Rx_EX) && (Rx_EX!=5'b00000) && (GRF_En_EX);
	assign Stall_RS0_M1 = Tuse_RS0 && (Tnew_M==2'b01) && (Rs==Rx_MEM) && (Rx_MEM!=5'b00000) && (GRF_En_MEM);
	assign Stall_RS1_E2 = Tuse_RS1 && (Tnew_E==2'b10) && (Rs==Rx_EX) && (Rx_EX!=5'b00000)&& (GRF_En_EX);
	assign Stall_RS = Stall_RS0_E1 || Stall_RS0_E2 || Stall_RS0_M1 || Stall_RS1_E2;

	assign Stall_RT0_E1 = Tuse_RT0 && (Tnew_E==2'b01) && (Rt==Rx_EX) &&(Rx_EX!=5'b00000) && (GRF_En_EX);
	assign Stall_RT0_E2 = Tuse_RT0 && (Tnew_E==2'b10) && (Rt==Rx_EX) &&(Rx_EX!=5'b00000)&& (GRF_En_EX);
	assign Stall_RT0_M1 = Tuse_RT0 && (Tnew_M==2'b01) && (Rt==Rx_MEM) &&(Rx_MEM!=5'b00000)&& (GRF_En_MEM);
	assign Stall_RT1_E2 = Tuse_RT1 && (Tnew_E==2'b10) && (Rt==Rx_EX)&&(Rx_EX!=5'b00000) && (GRF_En_EX);
	assign Stall_RT = Stall_RT0_E1 || Stall_RT0_E2 || Stall_RT0_M1 || Stall_RT1_E2;

	assign Stall_MD = ((Busy||Start)&&(IsMD_ID));
	
	assign Stall = Stall_RS || Stall_RT||Stall_MD;
	
endmodule
//·ÅÔÚD¼¶
