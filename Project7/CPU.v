`timescale 1ns / 1ps
`include "MACRO.v"
`define Int    5'b00000
`define AdEL   5'b00100
`define AdES   5'b00101
`define RI     5'b01010
`define Ov     5'b01100
`define DM_Addr_start      32'h0000_0000
`define DM_Addr_end        32'h0000_2FFF
`define IM_Addr_start      32'h0000_3000
`define IM_Addr_end        32'h0000_4FFF
`define Timer0_Addr_start  32'h0000_7f00
`define Timer0_Addr_end    32'h0000_7f0B
`define Timer1_Addr_start  32'h0000_7f10
`define Timer1_Addr_end    32'h0000_7f1B
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:42:16 12/02/2020 
// Design Name: 
// Module Name:    CPU
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
module CPU(
	input clk,
	input reset,
	output[31:0] CPU_Addr,//ok
	output[31:0] CPU_WD,//ok
	input[31:0] CPU_RD,//ok
	output CPU_total_WeEn,//ok
	input[31:0] DEV_Addr,//ok
	input[31:0] DEV_WD,//ok
	output[31:0] DM_RD,//ok
	input We_DM,//ok
	input[5:0] HWInt,
	output[31:0] MacroPC
    );

wire[31:0] Instr_IF;
wire[31:0] PC8_Out_IF;
wire[31:0] PC_IF;
wire[31:0] Instr_ID;
wire[31:0] PC8_Out_ID;
wire[31:0] PC_ID;



wire[15:0] Imm16_IF;
wire[25:0] Imm26_IF;
wire[31:0] Reg_IF;
wire[31:0] Reg_IF_NEW;

wire[31:0] RD1_ID;
wire[31:0] RD2_ID;
wire[31:0] EXT_Out_ID;
wire[4:0] Rx_ID; 
wire[4:0] Rs_ID;
wire[4:0] Rt_ID;
wire[2:0] NPCOp_ID;

wire[31:0] Instr_EX;
wire[31:0] RD1_EX;
wire[31:0] RD2_EX;
wire[31:0] RD1_EX_NEW;
wire[31:0] RD2_EX_NEW;
wire[31:0] EXT_Out_EX;
wire[31:0] PC8_Out_EX;
wire[31:0] PC_EX;
wire[4:0] Rx_EX;
wire[4:0] Rs_EX;
wire[4:0] Rt_EX;
wire[31:0] ALU_Out_EX;
wire GRF_En_EX;
wire[31:0] MDU_Out_EX;
wire[31:0] CP0_Out_EX;
wire Busy;
wire Start;

wire[31:0] Instr_MEM;
wire[31:0] ALU_Out_MEM;
wire[31:0] RD2_MEM;
wire[31:0] PC8_Out_MEM;
wire[31:0] PC_MEM;
wire[4:0] Rx_MEM;
wire[4:0] Rs_MEM;
wire[4:0] Rt_MEM;
wire[31:0] DM_Out_MEM;
wire[31:0] WrDM_MEM;
wire GRF_En_MEM;
wire[31:0] MDU_Out_MEM;
wire[31:0] CP0_Out_MEM;
wire WDM_En_MEM;

wire[31:0] Instr_WB;
wire[31:0] ALU_Out_WB;
wire[31:0] DM_Out_WB;
wire[31:0] PC8_Out_WB;
wire[31:0] PC_WB;
wire[4:0] Rx_WB;
wire GRF_En_WB;
wire[31:0] MDU_Out_WB;
wire[31:0] CP0_Out_WB;

wire[31:0] DM_True_Out_WB;

wire Tuse_RS0;
wire Tuse_RS1;
wire Tuse_RT0;
wire Tuse_RT1;
wire Tuse_RT2;

wire[1:0] Tnew_E;
wire[1:0] Tnew_M;

wire Stall;
//转发
wire[1:0] F_VALUE_MEM_SEL;
wire[31:0] F_VALUE_MEM;
wire[31:0] F_VALUE_WB;
wire[2:0] F_VALUE_WB_SEL;
wire[31:0] F_VALUE_EX;
//CP0相关
	 wire[31:0] EPC_EX;
	 wire IsFakeInstr; 
	 wire AddOverFlow;
	 wire SubOverFlow;
	 wire AdEL_E;
	 wire AdEL_F;
	 wire AdEL;
	 wire RI;
	 wire AdES;
    wire Ov;
    wire[4:0] Rd_EX;
	 	
	 wire LW_E;
	 wire LH_E;
	 wire LHU_E;
	 wire LB_E;
	 wire LBU_E;
	 wire SW_E;
	 wire SH_E;
	 wire SB_E;
	 wire ADD_E;
	 wire ADDI_E;
	 wire SUB_E;
	 wire ERET_E;
	 wire B_type_F;
	 wire J_type_F;
	 wire B_type_D;
	 wire J_type_D;
	 wire B_type_E;
	 wire J_type_E;
	 wire B_type_M;
	 wire J_type_M;
	 wire BD_EX;
	 wire BD_ID;
	 wire BD_IF;
	 wire MacroBD;
	 wire[31:0] PC_toCP0;
	 wire IntReqCP0;
	 wire CP0_En_E;
	 
	 wire ActivateCP0;
	 wire CoolCP0;
	 wire[4:0] ExcCode_F_only;
	 wire[4:0] ExcCode_D_only;
	 wire[4:0] ExcCode_E_only;
	 wire[4:0] ExcCode_True_F;
	 wire[4:0] ExcCode_True_D;
	 wire[4:0] ExcCode_True_E;
	 wire[4:0] ExcCode_F;
	 wire[4:0] ExcCode_D;
	 wire[4:0] ExcCode_E;
	 wire HaveIntExc_F;
	 wire HaveIntExc_D;
	 wire HaveIntExc_E;
	 
	 wire MacroPC_Use;
	 
	 wire HaveIntOrExc;

//
assign Imm16_IF = Instr_ID[15:0];
assign Imm26_IF = Instr_ID[25:0];
assign Reg_IF = RD1_ID;

assign Rs_ID = Instr_ID[25:21];
assign Rt_ID = Instr_ID[20:16];
assign Rs_EX = Instr_EX[25:21];
assign Rt_EX = Instr_EX[20:16];
assign Rs_MEM = Instr_MEM[25:21];
assign Rt_MEM = Instr_MEM[20:16];

F F(
	.Stall(Stall),
	.Imm16(Imm16_IF),
	.Imm26(Imm26_IF),
	.Reg(Reg_IF_NEW),
	.EPC(EPC_EX),///
	.ActivateCP0(ActivateCP0),///////////
	.CoolCP0(CoolCP0),////////
	.Rst(reset),
	.Clk(clk),
	.Instr(Instr_IF),
	.PC8_Out(PC8_Out_IF),
	.PC(PC_IF),
	.NPCOp_ID(NPCOp_ID)
    );
assign Reg_IF_NEW = ((Rs_ID==Rx_EX)&&(Rx_EX!=5'b00000)&&(Tnew_E==2'b00)&&(GRF_En_EX))? F_VALUE_EX:
							((Rs_ID==Rx_MEM)&&(Rx_MEM!=5'b00000)&&(Tnew_M==2'b00)&&(GRF_En_MEM))? F_VALUE_MEM:
							 ((Rs_ID==Rx_WB)&&(Rx_WB!=5'b00000)&&(GRF_En_WB))? F_VALUE_WB:
																												Reg_IF;
//F级异常
wire PC_OutBound;
wire PC_not_4;

assign PC_OutBound = (~((PC_IF[31:0]>=`IM_Addr_start)&&(PC_IF[31:0]<=`IM_Addr_end)));
assign PC_not_4 = (PC_IF[1:0]!=2'b00);																									
assign AdEL_F = (PC_OutBound||PC_not_4);

IF_ID IF_ID(
    .Instr_IF(Instr_IF),
    .PC8_Out_IF(PC8_Out_IF),
    .PC_IF(PC_IF),
	 .BD_IF(BD_IF),
	 .Stall(Stall),
	 .ActivateCP0(ActivateCP0),/////////
	 .CoolCP0(CoolCP0),/////////////刚加的
	 .AdEL_F(AdEL_F),
    .Instr_ID(Instr_ID),
    .PC8_Out_ID(PC8_Out_ID),
    .PC_ID(PC_ID),
	 .BD_ID(BD_ID),
	 .Clk(clk),
	 .Rst(reset),
	 .ExcCode_True_F(ExcCode_True_F),
	 .ExcCode_D(ExcCode_D)
    );
	 

	 assign ExcCode_F_only = (AdEL_F)? `AdEL: 5'b00000;
	 assign HaveIntExc_F = AdEL_F;
	 assign ExcCode_True_F = ExcCode_F_only;
	 
IF_ID_IntExc IF_ID_IntExc(
	.ExcCode_True_F(),
	.ExcCode_D(),
	.Clk(),
	.Rst(),
	.ActivateCP0(),
	.CoolCP0()
    );


Ctrl Decoder_D(
	.Instr(Instr_ID),
	.IsLW(),
	.IsLH(),
	.IsLHU(),
	.IsLB(),
	.IsLBU(),
	.IsSW(),
	.IsSH(),
	.IsSB(),
	.IsADD(),
	.IsADDI(),
	.IsSUB(),
	.IsB_type(B_type_D),
	.IsJ_type(J_type_D),
	.IsERET(),
	.IsFakeInstr(IsFakeInstr)
	 );
	 
D D(
	.Instr(Instr_ID),
	.RD1_NEW(RD1_ID),
	.RD2_NEW(RD2_ID),
	.EXT_Out(EXT_Out_ID),
	.Rx(Rx_ID),
	.Zero(),
	.Large(),
	.Little(),
	.Equal(),
	.Instr_W(Instr_WB),
	.ALU_Out_W(ALU_Out_WB),
	.DM_Out_W(DM_Out_WB),
	.PC8_Out_W(PC8_Out_WB),
	.MDU_Out_W(MDU_Out_WB),
	.CP0_Out_W(CP0_Out_WB),
	.PC_W(PC_WB),
	.Rx_W(Rx_WB),
	.DM_True_Out_W(DM_True_Out_WB),
	.Clk(clk),
	.Rst(reset),
	.NPCOp_ID(NPCOp_ID),
	.Rx_E(Rx_EX),
	.Rx_M(Rx_MEM),
	.F_VALUE_E(F_VALUE_EX),
	.F_VALUE_M(F_VALUE_MEM),
	.F_VALUE_W(F_VALUE_WB),
	.GRF_En_E(GRF_En_EX),
	.GRF_En_M(GRF_En_MEM),
	.GRF_En_W(GRF_En_WB),
	.Tnew_E(Tnew_E),
	.Tnew_M(Tnew_M)
    );

//D级异常，未知指令
assign RI = IsFakeInstr;

//转发D

//
//D兼有W级的功能
///////////////暂停控制（D级）
Tuse Tuse(
	.Instr(Instr_ID),
	.Tuse_RS0(Tuse_RS0),
	.Tuse_RS1(Tuse_RS1),
	.Tuse_RT0(Tuse_RT0),
	.Tuse_RT1(Tuse_RT1),
	.Tuse_RT2(Tuse_RT2)
    );
Tnew Tnew(
	.Instr(Instr_ID),
	.Tnew_E(Tnew_E),
	.Tnew_M(Tnew_M),
	.Clk(clk),
	.Rst(reset)
    );
Stall Stall_Module(
	.Instr_ID(Instr_ID),
	.Start(Start),
	.Busy(Busy),
	.Rs(Rs_ID),
	.Rt(Rt_ID),
	.Rx_EX(Rx_EX),
	.Rx_MEM(Rx_MEM),
	.Rx_WB(Rx_WB),
	.Tuse_RS0(Tuse_RS0),
	.Tuse_RS1(Tuse_RS1),
	.Tuse_RT0(Tuse_RT0),
	.Tuse_RT1(Tuse_RT1),
	.Tuse_RT2(Tuse_RT2),
	.Tnew_E(Tnew_E),
	.Tnew_M(Tnew_M),
	.GRF_En_EX(GRF_En_EX),
	.GRF_En_MEM(GRF_En_MEM),
	.Stall(Stall)
    );
////////////////
ID_EX ID_EX(
	 .Stall(Stall),
	 .ActivateCP0(ActivateCP0),//////////////
	 .CoolCP0(CoolCP0),/////////////刚加的
	 .RI(RI),
	 .Instr_ID(Instr_ID),
    .RD1_ID(RD1_ID),
    .RD2_ID(RD2_ID),
    .EXT_Out_ID(EXT_Out_ID),
    .PC8_Out_ID(PC8_Out_ID),
    .PC_ID(PC_ID),
    .Rx_ID(Rx_ID),
	 .BD_ID(BD_ID),
	 .Instr_EX(Instr_EX),
    .RD1_EX(RD1_EX),
    .RD2_EX(RD2_EX),
    .EXT_Out_EX(EXT_Out_EX),
    .PC8_Out_EX(PC8_Out_EX),
    .PC_EX(PC_EX),
    .Rx_EX(Rx_EX),
	 .BD_EX(BD_EX),
    .Clk(clk),
	 .Rst(reset),
	 .ExcCode_True_D(ExcCode_True_D),
	 .ExcCode_E(ExcCode_E)
    );
	 
	 
	 
	 assign ExcCode_D_only = (RI)? `RI: 5'b00000;
	 assign HaveIntExc_D = RI;
	 assign ExcCode_True_D = (HaveIntExc_D)? ExcCode_D_only: ExcCode_D;
	 
ID_EX_IntExc ID_EX_IntExc(
	.ExcCode_True_D(),
	.ExcCode_E(),
	.Clk(),
	.Rst(),
	.ActivateCP0(),
	.CoolCP0()
    );
assign RD1_EX_NEW = ((Rs_EX==Rx_MEM)&&(Rx_MEM!=5'b00000)&&(Tnew_M==2'b00)&&(GRF_En_MEM))? F_VALUE_MEM:
						  ((Rs_EX==Rx_WB)&&(Rx_WB!=5'b00000)&&(GRF_En_WB))? F_VALUE_WB:
																										RD1_EX;
assign RD2_EX_NEW = ((Rt_EX==Rx_MEM)&&(Rx_MEM!=5'b00000)&&(Tnew_M==2'b00)&&(GRF_En_MEM))? F_VALUE_MEM:
						  ((Rt_EX==Rx_WB)&&(Rx_WB!=5'b00000)&&(GRF_En_WB))? F_VALUE_WB:
																										RD2_EX;

E E(
	.Instr(Instr_EX),
	.RD1(RD1_EX_NEW),
	.RD2(RD2_EX_NEW),
	.EXT_Out(EXT_Out_EX),
	.ALU_Out(ALU_Out_EX),
	.GRF_En(GRF_En_EX),
	.Rx_MEM(Rx_MEM),
	.Rx_WB(Rx_WB),
	.Tnew_M(Tnew_M),
	.GRF_En_MEM(GRF_En_MEM),
	.GRF_En_WB(GRF_En_WB),
	.Clk(clk),
	.Rst(reset),
	.HaveIntOrExc(HaveIntOrExc),
	.F_VALUE_MEM(F_VALUE_MEM),
	.F_VALUE_WB(F_VALUE_WB),
	.MDU_Out(MDU_Out_EX),
	.Start(Start),
	.Busy(Busy),
	.AddOverFlow(AddOverFlow),
	.SubOverFlow(SubOverFlow)
    );

	 
Ctrl Decoder_E(
	.Instr(Instr_EX),
	.IsLW(LW_E),
	.IsLH(LH_E),
	.IsLHU(LHU_E),
	.IsLB(LB_E),
	.IsLBU(LBU_E),
	.IsSW(SW_E),
	.IsSH(SH_E),
	.IsSB(SB_E),
	.IsADD(ADD_E),
	.IsADDI(ADDI_E),
	.IsSUB(SUB_E),
	.IsB_type(B_type_E),
	.IsJ_type(J_type_E),
	.IsERET(ERET_E),
	.IsFakeInstr(),
	.CP0_En(CP0_En_E)
	 );

assign F_VALUE_EX = PC8_Out_EX;
//E级异常
//取数异常
wire ALU_EX_HitDM = ((ALU_Out_EX[31:0]>=`DM_Addr_start)&&(ALU_Out_EX[31:0]<=`DM_Addr_end));
wire ALU_EX_HitTimer0=((ALU_Out_EX[31:0]>=`Timer0_Addr_start)&&(ALU_Out_EX[31:0]<=`Timer0_Addr_end));
wire ALU_EX_HitTimer1=((ALU_Out_EX[31:0]>=`Timer1_Addr_start)&&(ALU_Out_EX[31:0]<=`Timer1_Addr_end));

wire LW_not_4 = ((LW_E)&&(ALU_Out_EX[1:0]!=2'b00));
wire LH_not_2 = ((LH_E||LHU_E)&&(ALU_Out_EX[0]!=1'b0));
wire LBH_fromTimer = ((LH_E||LHU_E||LB_E||LBU_E)&&(ALU_EX_HitTimer0||ALU_EX_HitTimer1));
wire Load_OverFlow = ((LW_E||LH_E||LHU_E||LB_E||LBU_E)&&(AddOverFlow));
wire Load_OutBount = ((LW_E||LH_E||LHU_E||LB_E||LBU_E)&&(~ALU_EX_HitDM && ~ALU_EX_HitTimer0 && ~ALU_EX_HitTimer1));
assign AdEL_E = (LW_not_4||LH_not_2||LBH_fromTimer||Load_OverFlow||Load_OutBount);

assign AdEL = AdEL_E||AdEL_F;


//存数异常
wire ALU_EX_HitTimer0_count = ((ALU_Out_EX[31:0]>=32'h0000_7F08)&&(ALU_Out_EX[31:0]<=32'h0000_7F0B));
wire ALU_EX_HitTimer1_count = ((ALU_Out_EX[31:0]>=32'h0000_7F18)&&(ALU_Out_EX[31:0]<=32'h0000_7F1B));
wire SW_not_4 = ((SW_E)&&(ALU_Out_EX[1:0]!=2'b00));
wire SH_not_2 = ((SH_E)&&(ALU_Out_EX[0]!=1'b0));
wire SHB_toTimer = ((SH_E||SB_E)&&(ALU_EX_HitTimer0||ALU_EX_HitTimer1));
wire Store_OverFlow = ((SW_E||SH_E||SB_E)&&(AddOverFlow));
wire Store_toCount = ((SW_E||SH_E||SB_E)&&(ALU_EX_HitTimer0_count||ALU_EX_HitTimer1_count));
wire Store_OutBound = ((SW_E||SH_E||SB_E)&&(~ALU_EX_HitDM && ~ALU_EX_HitTimer0 && ~ALU_EX_HitTimer1));
assign AdES = (SW_not_4||SH_not_2||SHB_toTimer||Store_OverFlow||Store_toCount||Store_OutBound);

//算数溢出
assign Ov = ((ADD_E && AddOverFlow)||(ADDI_E && AddOverFlow)||(SUB_E && SubOverFlow));

//BD设置
//assign MacroPC = PC_EX;

assign MacroPC = (PC_EX||ExcCode_True_E)? (PC_EX):
						(PC_ID||ExcCode_True_D)? (PC_ID):
						(PC_IF)? (PC_IF): 0;


assign BD_IF = ((B_type_D)||(J_type_D))? 1'b1: 1'b0;

assign MacroBD = (PC_EX||ExcCode_True_E)? (BD_EX):
						(PC_ID||ExcCode_True_D)? (BD_ID):
						(PC_IF)? (BD_IF): 1'b0;
assign PC_toCP0 = (MacroBD)? (MacroPC - 4): MacroPC;

assign Rd_EX = Instr_EX[15:11];



//CP0,读写分离
CP0 CP0(
	.A_RD(Rd_EX),
	.A_WR(Rd_EX),
	.WD(RD2_EX_NEW),
	.RD(CP0_Out_EX),//CP0的结果要随着流水传递，需要添加ok
	.We(CP0_En_E),//需要添加ok
	.PC(PC_toCP0),
	.HWInt(HWInt),
	.ExcCode_(ExcCode_True_E),//需要添加ok
	.EPC(EPC_EX),
	//.IP(),
	.IntReq(IntReqCP0),
	.Clk(clk),
	.Rst(reset),
	.BD_(MacroBD),
	.ActivateCP0(ActivateCP0),
	.CoolCP0(CoolCP0)
    );
	 
	 assign ExcCode_E_only = (IntReqCP0)? `Int:
									 (AdEL_E)? `AdEL:
									 (AdES)? `AdES:
									 (Ov)? `Ov:
									          5'b00000;
	assign HaveIntExc_E = (IntReqCP0||AdEL_E||AdES||Ov);
	assign ExcCode_True_E = (HaveIntExc_E)? ExcCode_E_only: ExcCode_E;

	assign ActivateCP0 = ((IntReqCP0)||(ExcCode_True_E!=5'b00000))? 1'b1: 1'b0;
	assign CoolCP0 = (ERET_E)? 1'b1: 1'b0;
	
	assign HaveIntOrExc = ActivateCP0;
EX_MEM EX_MEM(
	 .ActivateCP0(ActivateCP0),////////刚加的
    .Instr_EX(Instr_EX),
    .ALU_Out_EX(ALU_Out_EX),
	 .MDU_Out_EX(MDU_Out_EX),
	 .CP0_Out_EX(CP0_Out_EX),
    .RD2_EX(RD2_EX_NEW),
    .PC8_Out_EX(PC8_Out_EX),
    .PC_EX(PC_EX),
    .Rx_EX(Rx_EX),
	 .Instr_MEM(Instr_MEM),
    .ALU_Out_MEM(ALU_Out_MEM),
	 .MDU_Out_MEM(MDU_Out_MEM),
	 .CP0_Out_MEM(CP0_Out_MEM),
    .RD2_MEM(RD2_MEM),
    .PC8_Out_MEM(PC8_Out_MEM),
    .PC_MEM(PC_MEM),
    .Rx_MEM(Rx_MEM),
    .Clk(clk),
	 .Rst(reset)
    );
	assign WrDM_MEM = ((Rt_MEM==Rx_WB)&&(Rx_WB!=5'b00000)&&(GRF_En_WB))? F_VALUE_WB: RD2_MEM;
	assign CPU_WD = WrDM_MEM;
	assign CPU_Addr = ALU_Out_MEM;
	assign CPU_total_WeEn = WDM_En_MEM;
M M(
	.Instr(Instr_MEM),
	.ALU_Out(DEV_Addr),//pay attention!
	.WrDM(DEV_WD),//pay attention!
	.PC(PC_MEM),
	.Clk(clk),
	.Rst(reset),
	.DM_Out(DM_RD),///pay attention!
	.GRF_En(GRF_En_MEM),
	.GRF_En_WB(GRF_En_WB),
	.F_VALUE_WB(F_VALUE_WB),
	.Rx_WB(Rx_WB),
	.WDM_En(WDM_En_MEM),
	.We_DM(We_DM)
    );
	 assign DM_Out_MEM = CPU_RD;

Ctrl Decoder_M(
	.Instr(Instr_MEM),
	.IsLW(),
	.IsLH(),
	.IsLHU(),
	.IsLB(),
	.IsLBU(),
	.IsSW(),
	.IsSH(),
	.IsSB(),
	.IsADD(),
	.IsADDI(),
	.IsSUB(),
	.IsB_type(B_type_M),
	.IsJ_type(J_type_M),
	.IsERET(),
	.IsFakeInstr()
	 ); 
//////////转发
MUX_F_VALUE_MEM MUX_F_VALUE_MEM(
	.ALU(ALU_Out_MEM),
	.IFU(PC8_Out_MEM),
	.MDU(MDU_Out_MEM),
	.CP0(CP0_Out_MEM),///新添加
	.F_VALUE_MEM_SEL(F_VALUE_MEM_SEL),
	.F_VALUE_MEM(F_VALUE_MEM)
	);
	
Ctrl Ctrl_MEM(
	.Instr(Instr_MEM),
	.Zero(),
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
	.F_VALUE_MEM_SEL(F_VALUE_MEM_SEL)
    );
/////////////
MEM_WB MEM_WB(
    .Instr_MEM(Instr_MEM),
    .ALU_Out_MEM(ALU_Out_MEM),
	 .MDU_Out_MEM(MDU_Out_MEM),
    .DM_Out_MEM(DM_Out_MEM),
	 .CP0_Out_MEM(CP0_Out_MEM),
    .PC8_Out_MEM(PC8_Out_MEM),
	 .PC_MEM(PC_MEM),
    .Rx_MEM(Rx_MEM),
	 .Instr_WB(Instr_WB),
    .ALU_Out_WB(ALU_Out_WB),
	 .MDU_Out_WB(MDU_Out_WB),
    .DM_Out_WB(DM_Out_WB),
	 .CP0_Out_WB(CP0_Out_WB),
    .PC8_Out_WB(PC8_Out_WB),
	 .PC_WB(PC_WB),
    .Rx_WB(Rx_WB),
    .Clk(clk),
	 .Rst(reset)
    );
////////转发有关

MUX_F_VALUE_WB MUX_F_VALUE_WB(
	.ALU(ALU_Out_WB),
	.DM(DM_True_Out_WB),
	.IFU(PC8_Out_WB),
	.MDU(MDU_Out_WB),
	.CP0(CP0_Out_WB),//////新添加
	.F_VALUE_WB_SEL(F_VALUE_WB_SEL),
	.F_VALUE_WB(F_VALUE_WB)
	);
	
Ctrl Ctrl_WB(
	.Instr(Instr_WB),
	.Zero(),
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
	.F_VALUE_WB_SEL(F_VALUE_WB_SEL),
	.F_VALUE_MEM_SEL()
    );
////////


//W W(
//	.Instr(Instr_WB),
//	.ALU_Out(ALU_Out_WB),
//	.DM_Out(DM_Out_WB),
//	.PC4_Out(PC4_Out_WB),
//	.PC(PC_WB),
//	.Rx(Rx_WB),
//	.Clk(clk),
//	.Rst(reset)
//	);
	
endmodule

