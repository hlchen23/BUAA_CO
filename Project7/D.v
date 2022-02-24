`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:35:56 12/02/2020 
// Design Name: 
// Module Name:    D 
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
module D(
	input[31:0] Instr,
	output[31:0] RD1_NEW,
	output[31:0] RD2_NEW,
	output[31:0] EXT_Out,
	output[4:0] Rx,
	output Zero,
	output Large,
	output Little,
	output Equal,
	//W
	input[31:0] Instr_W,
	input[31:0] ALU_Out_W,
	input[31:0] DM_Out_W,
	input[31:0] PC8_Out_W,
	input[31:0] MDU_Out_W,
	input[31:0] CP0_Out_W,
	input[31:0] PC_W,
	input[4:0] Rx_W,
	output[31:0] DM_True_Out_W,
	//
	input[4:0] Rx_E,
	input[4:0] Rx_M,
	input[31:0] F_VALUE_E,
	input[31:0] F_VALUE_M,
	input[31:0] F_VALUE_W,
	input GRF_En_E,
	input GRF_En_M,
	output GRF_En_W,
	input[1:0] Tnew_E,
	input[1:0] Tnew_M,
	input Clk,
	input Rst,
	output[2:0] NPCOp_ID
    );
	wire[4:0] Rs;
	wire[4:0] Rt;
	wire[4:0] Rd;
	wire[31:0] RD1;
	wire[31:0] RD2;
	wire[15:0] EXT_In;
	wire EXTOp;
	wire EXT_Source;
	wire[1:0] A3Sel;
	wire[15:0] Imm16;
	wire[4:0] Offset;
	wire GRF_En;
	wire[31:0] COMP1;
	wire[31:0] COMP2;
	//W
	wire[31:0] WrReg_W;
	wire[2:0] WrRegSel_W;
	wire[2:0] DM_VALUE_Op;
	//
	assign Rs = Instr[25:21];
	assign Rt = Instr[20:16];
	assign Rd = Instr[15:11];
	assign Imm16 = Instr[15:0];
	assign Offset = Instr[10:6];
	GRF GRF(
			.A1(Rs),
			.A2(Rt),
			.A3(Rx_W),
			.WrReg(WrReg_W),
			.GRF_En(GRF_En_W),
			.Clk(Clk),
			.Rst(Rst),
			.RD1(RD1),
			.RD2(RD2),
			.PC(PC_W)
			);
	
	MUX_EXT_Source MUX_EXT_Source(
			.Imm16(Imm16),
			.Offset(Offset),
			.EXT_Source(EXT_Source),
			.Out(EXT_In)
			);
	EXT EXT(
			.In(EXT_In),
			.Out(EXT_Out),
			.EXTOp(EXTOp)
			);
	COMP COMP(
			.COMP1(COMP1),
			.COMP2(COMP2),
			.Zero(Zero),
			.Large(Large),
			.Little(Little),
			.Equal(Equal)
			);
	//转发
	assign RD1_NEW = ((Rs==Rx_E)&&(Rx_E!=5'b00000)&&(Tnew_E==2'b00)&&(GRF_En_E))? F_VALUE_E:
                    ((Rs==Rx_M)&&(Rx_M!=5'b00000)&&(Tnew_M==2'b00)&&(GRF_En_M))? F_VALUE_M:
						   ((Rs==Rx_W)&&(Rx_W!=5'b00000)&&(GRF_En_W))? F_VALUE_W:
																											RD1;
	assign RD2_NEW = ((Rt==Rx_E)&&(Rx_E!=5'b00000)&&(Tnew_E==2'b00)&&(GRF_En_E))? F_VALUE_E:
                    ((Rt==Rx_M)&&(Rx_M!=5'b00000)&&(Tnew_M==2'b00)&&(GRF_En_M))? F_VALUE_M:
						   ((Rt==Rx_W)&&(Rx_W!=5'b00000)&&(GRF_En_W))? F_VALUE_W:
																											RD2;
	assign COMP1 = RD1_NEW;
	assign COMP2 = RD2_NEW;
	//

	 
	MUX_A3Sel MUX_A3Sel(
				.Rt(Rt),
				.Rd(Rd),
				.A3Sel(A3Sel),
				.Out(Rx)
				);
	Ctrl Ctrl(
			.Instr(Instr),
			.Zero(Zero),
			.Large(Large),
			.Little(Little),
			.Equal(Equal),
			.NPCOp(NPCOp_ID),
			.GRF_En(GRF_En),
			.EXTOp(EXTOp),
			.ALUOp(),
			.WDM_En(),
			.A3Sel(A3Sel),
			.WrRegSel(),
			.ALU_AOp(),
			.ALU_BOp(),
			.EXT_Source(EXT_Source),
			.F_VALUE_WB_SEL(),
			.F_VALUE_MEM_SEL(),
			.Start(),
			.IsMD(),
			.MDU_Out_Sel(),
			.HI_En(),
			.LO_En(),
			.BE_LOCATE_Op(),
			.DM_VALUE_Op(),
			.MDU_Sel()
			);
	//W
	MUX_WrRegSel MUX_WrRegSel(
				.ALU_Out(ALU_Out_W),
				.DM_Out(DM_True_Out_W),
				.PC8_Out(PC8_Out_W),
				.MDU_Out(MDU_Out_W),
				.CP0_Out(CP0_Out_W),//////新添加
				.WrRegSel(WrRegSel_W),
				.Out(WrReg_W)
				);
				
	DM_VALUE_EXT DM_VALUE_EXT(
				.DM_Addr(ALU_Out_W),
				.DM_EXT_In(DM_Out_W),
				.DM_VALUE_Op(DM_VALUE_Op),
				.DM_True_Out(DM_True_Out_W)
    );
	Ctrl Ctrl_W(
			.Instr(Instr_W),
			.Zero(),
			.Large(),
			.Little(),
			.Equal(),
			.NPCOp(),
			.GRF_En(GRF_En_W),
			.EXTOp(),
			.ALUOp(),
			.WDM_En(),
			.A3Sel(),
			.WrRegSel(WrRegSel_W),
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
			.BE_LOCATE_Op(),
			.DM_VALUE_Op(DM_VALUE_Op),
			.MDU_Sel()
			);
endmodule
