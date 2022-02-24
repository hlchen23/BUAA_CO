`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:36:52 12/02/2020 
// Design Name: 
// Module Name:    E 
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
module E(
	input[31:0] Instr,
	input[31:0] RD1,
	input[31:0] RD2,
	input[31:0] EXT_Out,
	input[4:0] Rx_MEM,
	input[4:0] Rx_WB,
	input[1:0] Tnew_M,
	input GRF_En_MEM,
	input GRF_En_WB,
	input[31:0] F_VALUE_MEM,
	input[31:0] F_VALUE_WB,
	input Clk,
	input Rst,
	input HaveIntOrExc,
	output[31:0] ALU_Out,
	output[31:0] MDU_Out,
	output GRF_En,
	output Start,
	output Busy,
	output AddOverFlow,
	output SubOverFlow
    );
	wire[4:0] ALUOp;
	wire[1:0] ALU_AOp;
	wire[1:0] ALU_BOp;
	wire[31:0] ALU_A;
	wire[31:0] ALU_B;
	wire[4:0] Rs;
	wire[4:0] Rt;
	wire HI_En;
	wire LO_En;
	wire[31:0] R_HI;
	wire[31:0] R_LO;
	wire[1:0] MDU_Sel;
	wire MDU_Out_Sel;
	
	assign Rs = Instr[25:21];
	assign Rt = Instr[20:16];
	
	
//	  assign RD1_NEW = ((Rs==Rx_MEM)&&(Rx_MEM!=5'b00000)&&(Tnew_M==2'b00)&&(GRF_En_MEM))? F_VALUE_MEM:
//						  ((Rs==Rx_WB)&&(Rx_WB!=5'b00000)&&(GRF_En_WB))? F_VALUE_WB:
//																									RD1;
//   这里只更新了参与运算的RD2，记得要更新向下传递的RD2	
//	  assign RD2_NEW = ((Rt==Rx_MEM)&&(Rx_MEM!=5'b00000)&&(Tnew_M==2'b00)&&(GRF_En_MEM))? F_VALUE_MEM:
//						  ((Rt==Rx_WB)&&(Rx_WB!=5'b00000)&&(GRF_En_WB))? F_VALUE_WB:
//																										RD2;
	MUX_ALU_AOp MUX_ALU_AOp(
				.GRF_RD1(RD1),
				.EXT_Out(EXT_Out),
				.ALU_AOp(ALU_AOp),
				.Out(ALU_A)
				);
	MUX_ALU_BOp MUX_ALU_BOp(
				.GRF_RD2(RD2),
				.EXT_Out(EXT_Out),
				.ALU_BOp(ALU_BOp),
				.Out(ALU_B)
				);
	ALU ALU(
				.ALU_A(ALU_A),
				.ALU_B(ALU_B),
				.Zero(),
				.ALU_Out(ALU_Out),
				.ALUOp(ALUOp),
				.AddOverFlow(AddOverFlow),/////////
				.SubOverFlow(SubOverFlow)/////////新添加
				);

	MDU MDU(
				.MDU_D1(RD1),
				.MDU_D2(RD2),
				.WrHL(RD1),
				.HI_En(HI_En),
				.LO_En(LO_En),
				.MDU_Sel(MDU_Sel),
				.Start(Start),
				.Clk(Clk),
				.Rst(Rst),
				.HaveIntOrExc(HaveIntOrExc),
				.R_HI(R_HI),
				.R_LO(R_LO),
				.Busy(Busy)
    );
	 
	MUX_MDU_Out_Sel MUX_MDU_Out_Sel(
	.HI(R_HI),
	.LO(R_LO),
	.MDU_Out_Sel(MDU_Out_Sel),
	.MDU_Out(MDU_Out)
	);
	Ctrl Ctrl(
			.Instr(Instr),
			.Zero(),
			.Large(),
			.Little(),
			.Equal(),
			.NPCOp(),
			.GRF_En(GRF_En),
			.EXTOp(),
			.ALUOp(ALUOp),
			.WDM_En(),
			.A3Sel(),
			.WrRegSel(),
			.ALU_AOp(ALU_AOp),
			.ALU_BOp(ALU_BOp),
			.EXT_Source(),
			.F_VALUE_WB_SEL(),
			.F_VALUE_MEM_SEL(),
			.Start(Start),
			.IsMD(),
			.MDU_Out_Sel(MDU_Out_Sel),
			.HI_En(HI_En),
			.LO_En(LO_En),
			.BE_LOCATE_Op(),
			.DM_VALUE_Op(),
			.MDU_Sel(MDU_Sel)
			);

endmodule
