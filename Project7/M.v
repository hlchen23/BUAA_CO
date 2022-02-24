`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:40:27 12/02/2020 
// Design Name: 
// Module Name:    M 
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
module M(
	input[31:0] Instr,
	input[31:0] ALU_Out,
	input[31:0] WrDM,
	input[31:0] PC,
	input GRF_En_WB,
	input[31:0] F_VALUE_WB,
	input[4:0] Rx_WB,
	input Clk,
	input Rst,
	output[31:0] DM_Out,
	output GRF_En,
	output WDM_En,
	input We_DM
    );
	wire[4:0] Rt_MEM = Instr[20:16];
	wire[31:0] RD2_NEW;
	wire[1:0] BE_LOCATE_Op;
	wire[3:0] Byte_En;
	
	BE_LOCATE BE_LOCATE(
			.DM_Addr(ALU_Out),
			.BE_LOCATE_Op(BE_LOCATE_Op),
			.Byte_En(Byte_En)
    );
	DM DM(
			.DM_Addr(ALU_Out),
			.WrDM(WrDM),
			.WDM_En(We_DM),//此来源于系统桥
			.Byte_En(Byte_En),
			.Clk(Clk),
			.Rst(Rst),
			.DM_Out(DM_Out),
			.PC(PC)
			);
//	assign RD2_NEW = ((Rt_MEM==Rx_WB)&&(Rx_WB!=5'b00000)&&(GRF_En_WB))? F_VALUE_WB: RD2;
	Ctrl Ctrl(
			.Instr(Instr),
			.Zero(),
			.Large(),
			.Little(),
			.Equal(),
			.NPCOp(),
			.GRF_En(GRF_En),
			.EXTOp(),
			.ALUOp(),
			.WDM_En(WDM_En),
			.A3Sel(),
			.WrRegSel(),
			.ALU_AOp(),
			.ALU_BOp(),
			.EXT_Source(),
			.F_VALUE_WB_SEL(),
			.F_VALUE_MEM_SEL(),
			.Start(),
			.IsMD(),
			.MDU_Out_Sel(),
			.HI_En(),
			.LO_En(),
			.BE_LOCATE_Op(BE_LOCATE_Op),
			.DM_VALUE_Op(),
			.MDU_Sel()
			);
endmodule
