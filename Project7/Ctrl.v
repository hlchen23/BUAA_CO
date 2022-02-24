`timescale 1ns / 1ps
`include "MACRO.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:26:03 12/02/2020 
// Design Name: 
// Module Name:    Ctrl 
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
module Ctrl(
	input[31:0] Instr,
	input Zero,
	input Large,
	input Little,
	input Equal,
	output[2:0] NPCOp,
	output GRF_En,
	output EXTOp,
	output[4:0] ALUOp,
	output WDM_En,
	output[1:0] A3Sel,
	output[2:0] WrRegSel,
	output[1:0] ALU_AOp,
	output[1:0] ALU_BOp,
	output EXT_Source,
	output[2:0] F_VALUE_WB_SEL,
	output[1:0] F_VALUE_MEM_SEL,
	output Start,
	output IsMD,
	output MDU_Out_Sel,
	output HI_En,
	output LO_En,
	output[1:0] BE_LOCATE_Op,
	output[2:0] DM_VALUE_Op,
	output[1:0] MDU_Sel,
	output CP0_En,
	
	output IsLW,
	output IsLH,
	output IsLHU,
	output IsLB,
	output IsLBU,
	output IsSW,
	output IsSH,
	output IsSB,
	output IsADD,
	output IsADDI,
	output IsSUB,
	output IsB_type,
	output IsJ_type,
	output IsERET,
	output IsFakeInstr
    );
	 
	wire[5:0] Opcode;
	wire[5:0] Func;
	wire[4:0] Rt;
	wire[4:0] Rs;
	wire[11:0] total;
	wire[10:0] OpRt;
	wire[10:0] OpRs;
	assign Opcode = Instr[31:26];
	assign Func = Instr[5:0];
	assign Rs = Instr[25:21];
	assign Rt = Instr[20:16];
	assign total = {Opcode,Func};
	assign OpRt = {Opcode,Rt};
	assign OpRs = {Opcode,Rs};
	/////////////////////////////
	wire ADDU;
	wire SUBU;
	wire ADD;
	wire SUB;
	wire AND;
	wire OR;
	wire XOR;
	wire NOR;
	wire SLT;
	wire SLTU;
	wire SLLV;
	wire SRLV;
	wire SRAV;
	
	wire ADDIU;
	wire ADDI;
	wire ANDI;
	wire XORI;
	wire ORI;
	wire SLTI;
	wire SLTIU;
	
	wire LUI;
	
	wire BEQ;
	wire BNE;
	wire BLEZ;
	wire BGTZ;
	wire BLTZ;
	wire BGEZ;
	
	wire JAL;
	wire J;
	wire JR;
	wire JALR;
	
	wire SLL;
	wire SRL;
	wire SRA;
	
	wire MULT;
	wire MULTU;
	wire DIV;
	wire DIVU;
	
	wire MFHI;
	wire MFLO;
	wire MTHI;
	wire MTLO;
	
	wire LW;
	wire LB;
	wire LBU;
	wire LH;
	wire LHU;
	
	wire SW;
	wire SB;
	wire SH;
	
	wire ERET;
	wire MFC0;
	wire MTC0;
	
	wire BEQ_NPC;
	wire BNE_NPC;
	wire BLEZ_NPC;
	wire BGTZ_NPC;
	wire BLTZ_NPC;
	wire BGEZ_NPC;
	
	assign ADDU = (total==`ADDU);
	assign SUBU = (total==`SUBU);
	assign ADD = (total==`ADD);
	assign SUB = (total==`SUB);
	assign AND = (total==`AND);
	assign OR = (total==`OR);
	assign XOR = (total==`XOR);
	assign NOR = (total==`NOR);
	assign SLT = (total==`SLT);
	assign SLTU = (total==`SLTU);
	assign SLLV = (total==`SLLV);
	assign SRLV = (total==`SRLV);
	assign SRAV = (total==`SRAV);
	
	assign ADDIU = (Opcode==`ADDIU);
	assign ADDI = (Opcode==`ADDI);
	assign ANDI = (Opcode==`ANDI);
	assign XORI = (Opcode==`XORI);
	assign ORI = (Opcode==`ORI);
	assign SLTI = (Opcode==`SLTI);
	assign SLTIU = (Opcode==`SLTIU);
	
	assign LUI = (Opcode==`LUI);
	
	assign BEQ = (Opcode==`BEQ);
	assign BNE = (Opcode==`BNE);
	assign BLEZ = (Opcode==`BLEZ);
	assign BGTZ = (Opcode==`BGTZ);
	assign BLTZ = (OpRt==`BLTZ);
	assign BGEZ = (OpRt==`BGEZ);
	
	assign JAL = (Opcode==`JAL);
	assign J = (Opcode==`J);
	assign JR = (total==`JR);
	assign JALR = (total==`JALR);
	
	assign SLL = (total==`SLL);
	assign SRL = (total==`SRL);
	assign SRA = (total==`SRA);
	
	assign MULT = (total==`MULT);
	assign MULTU = (total==`MULTU);
	assign DIV = (total==`DIV);
	assign DIVU = (total==`DIVU);
	
	assign MFHI = (total==`MFHI);
	assign MFLO = (total==`MFLO);
	assign MTHI = (total==`MTHI);
	assign MTLO = (total==`MTLO);
	
	assign LW = (Opcode==`LW);
	assign LB = (Opcode==`LB);
	assign LBU = (Opcode==`LBU);
	assign LH = (Opcode==`LH);
	assign LHU = (Opcode==`LHU);
	
	assign SW = (Opcode==`SW);
	assign SB = (Opcode==`SB);
	assign SH = (Opcode==`SH);
	
	assign ERET = (total==`ERET);
	assign MFC0 = (OpRs==`MFC0);
	assign MTC0 = (OpRs==`MTC0);
	
	assign BEQ_NPC = (BEQ &&(Zero==1'b1));
	assign BNE_NPC = (BNE &&(Zero==1'b0));
	assign BLEZ_NPC = (BLEZ &&((Little)||(Equal)));
	assign BGTZ_NPC = (BGTZ &&(Large));
	assign BLTZ_NPC = (BLTZ &&(Little));
	assign BGEZ_NPC = (BGEZ &&((Large)||(Equal)));
	
	assign IsLW = LW;
	assign IsLH = LH;
	assign IsLHU = LHU;
	assign IsLB = LB;
	assign IsLBU = LBU;
	assign IsSW = SW;
	assign IsSH = SH;
	assign IsSB = SB;
	assign IsADD = ADD;
	assign IsADDI = ADDI;
	assign IsSUB = SUB;
	assign IsB_type = BEQ||BNE||BLEZ||BGTZ||BLTZ||BGEZ;
	assign IsJ_type = J||JAL||JR||JALR;
	assign IsERET = ERET;
	assign IsFakeInstr = 
	(~(ADDU||SUBU||ADD||SUB||AND||OR||XOR||NOR||SLT||SLTU||SLLV||SRLV||SRAV
	||ADDIU||ADDI||ANDI||XORI||ORI||SLTI||SLTIU||LUI
	||BEQ||BNE||BLEZ||BGTZ||BLTZ||BGEZ
	||JAL||J||JR||JALR
	||SLL||SRL||SRA
	||MULT||MULTU||DIV||DIVU
	||MFHI||MFLO||MTHI||MTLO
	||LW||LB||LBU||LH||LHU
	||SW||SB||SH
	||ERET||MFC0||MTC0));
	//////////////////////////////
	
	//NPCOp
	wire NPCOp_0 = BEQ_NPC + BNE_NPC + BLEZ_NPC + BGTZ_NPC + BLTZ_NPC + BGEZ_NPC + JR + JALR;
	wire NPCOp_1 = J +JAL + JR + JALR;
	wire NPCOp_2 = 1'b0;
	assign NPCOp = {NPCOp_2,NPCOp_1,NPCOp_0};
	
	//GRF_En
	assign GRF_En = (ADDU+SUBU+ADD+SUB+AND+OR+XOR+NOR+SLT+SLTU+SLLV+SRLV+SRAV)
							+(ADDIU+ADDI+ANDI+XORI+ORI+SLTI+SLTIU)
							+LUI
							+(SLL+SRL+SRA)
							+(JAL+JALR)
							+(MFHI+MFLO)
							+(LW+LBU+LB+LHU+LH)
							+ MFC0;
	
	//EXTOp
	assign EXTOp = ADDIU + ADDI + SLTI + SLTIU + SW + SH + SB + LW + LBU + LB + LHU + LH;
	
	//ALUOp
	wire ALUOp_0 = SUBU + SUB + AND + NOR + SLTU + SLLV + SRAV + ANDI + SLTIU + SLL + SRA;
	wire ALUOp_1 = AND + OR + SLT + SLTU +SRLV + SRAV + ANDI + ORI + SLTI + SLTIU + SRL + SRA;
	wire ALUOp_2 = XOR + NOR + SLT + SLTU + XORI + SLTI + SLTIU;
	wire ALUOp_3 = SLLV + SRLV + SRAV + LUI + SLL + SRL + SRA;
	wire ALUOp_4 = 1'b0;
	assign ALUOp = {ALUOp_4,ALUOp_3,ALUOp_2,ALUOp_1,ALUOp_0};
	
	//WDM_En
	assign WDM_En = SW + SH + SB;
	
	//A3Sel
	wire A3Sel_0 = ADDU + SUBU + ADD + SUB + AND + OR 
						+XOR + NOR + SLT + SLTU
						+SLLV + SRLV + SRAV
						+SLL + SRL + SRA + JALR + MFHI + MFLO;
	wire A3Sel_1 = JAL;
	assign A3Sel = {A3Sel_1,A3Sel_0};
	
	//WrRegSel
	wire WrRegSel_0 = MFHI + MFLO + LW + LBU + LB + LHU + LH;
	wire WrRegSel_1 = JAL + JALR + MFHI + MFLO;
	wire WrRegSel_2 = MFC0;
	assign WrRegSel = {WrRegSel_2,WrRegSel_1,WrRegSel_0};
	
	//ALU_AOp
	wire ALU_AOp_0 = SLL + SRL + SRA;
	wire ALU_AOp_1 = 1'b0;
	assign ALU_AOp = {ALU_AOp_1,ALU_AOp_0};
	
	//ALU_BOp
	wire ALU_BOp_0 = ADDIU + ADDI +ANDI + XORI + ORI
							+ SLTI + SLTIU + LUI + SW + SH + SB
							+ LW + LBU + LB + LHU + LH;
	wire ALU_BOp_1 = 1'b0;
	assign ALU_BOp = {ALU_BOp_1,ALU_BOp_0};
	//EXT_Source
	assign EXT_Source = SLL + SRL + SRA;
	//F_VALUE_WB_SEL
	wire F_VALUE_WB_SEL_0 = MFHI + MFLO + LW + LBU + LB + LHU + LH;
	wire F_VALUE_WB_SEL_1 = JAL + JALR + MFHI + MFLO;
	wire F_VALUE_WB_SEL_2 = MFC0;
	assign F_VALUE_WB_SEL = {F_VALUE_WB_SEL_2,F_VALUE_WB_SEL_1,F_VALUE_WB_SEL_0};
	//F_VALUE_MEM_SEL
	wire F_VALUE_MEM_SEL_0 = JAL + JALR + MFC0;
	wire F_VALUE_MEM_SEL_1 = MFHI + MFLO + MFC0;
	assign F_VALUE_MEM_SEL = {F_VALUE_MEM_SEL_1,F_VALUE_MEM_SEL_0};
	//Start
	assign Start = MULT + MULTU + DIV + DIVU;
	//MDU_Out_Sel
	assign MDU_Out_Sel = MFLO;
	//HI_En
	assign HI_En = MTHI;
	//LO_En
	assign LO_En = MTLO;
	//BE_LOCATE_Op
	wire BE_LOCATE_Op_0 = SH;
	wire BE_LOCATE_Op_1 = SB;
	assign BE_LOCATE_Op = {BE_LOCATE_Op_1,BE_LOCATE_Op_0};
	//DM_VALUE_Op
	wire DM_VALUE_Op_0 = LBU + LHU;
	wire DM_VALUE_Op_1 = LB + LHU;
	wire DM_VALUE_Op_2 = LH;
	assign DM_VALUE_Op = {DM_VALUE_Op_2,DM_VALUE_Op_1,DM_VALUE_Op_0};
	//MDU_Sel
	wire MDU_Sel_0 = MULTU + DIVU;
	wire MDU_Sel_1 = DIV + DIVU;
	assign MDU_Sel = {MDU_Sel_1,MDU_Sel_0};
	//IsMD
	assign IsMD = MULT||MULTU||DIV||DIVU||MFHI||MFLO||MTHI||MTLO;
	//CP0_En
	assign CP0_En = MTC0;
//	always@(total,Zero)begin//组合逻辑，阻塞赋值
//		casex(total)
//			`ADDU:begin
//				NPCOp = 2'b00;
//				GRF_En = 1;
//				ALUOp = 2'b00;
//				WDM_En = 0;
//				A3Sel = 2'b01;
//				WrRegSel = 2'b00;
//				ALU_AOp = 2'b00;
//				ALU_BOp = 2'b00;
//				EXTOp = 0;
//				EXT_Source = 0;
//			end
//			`SUBU:begin
//				NPCOp = 2'b00;
//				GRF_En = 1;
//				ALUOp = 2'b01;
//				WDM_En = 0;
//				A3Sel = 2'b01;
//				WrRegSel = 2'b00;
//				ALU_AOp = 2'b00;
//				ALU_BOp = 2'b00;
//				EXTOp = 0;
//				EXT_Source = 0;
//			end
//			`ORI:begin
//				NPCOp = 2'b00;
//				GRF_En = 1;
//				EXTOp = 0;
//				ALUOp = 2'b10;
//				WDM_En = 0;
//				A3Sel = 2'b00;
//				WrRegSel = 2'b00;
//				ALU_AOp = 2'b00;
//				ALU_BOp = 2'b01;
//				EXT_Source = 0;
//			end
//			`LW:begin
//				NPCOp = 2'b00;
//				GRF_En = 1;
//				EXTOp = 1;
//				ALUOp = 2'b00;
//				WDM_En = 0;
//				A3Sel = 2'b00;
//				WrRegSel = 2'b01;
//				ALU_AOp = 2'b00;
//				ALU_BOp = 2'b01;
//				EXT_Source = 0;
//			end
//			`SW:begin
//				NPCOp = 2'b00;
//				GRF_En = 0;
//				EXTOp = 1;
//				ALUOp = 2'b00;
//				WDM_En = 1;
//				ALU_AOp = 2'b00;
//				ALU_BOp = 2'b01;
//				EXT_Source = 0;
//				A3Sel = 2'b00;
//				WrRegSel = 2'b00;
//			end
//			`BEQ:begin
//				NPCOp = (Zero==1)? 2'b01: 2'b00;
//				GRF_En = 0;
//				WDM_En = 0;
//				EXTOp = 0;
//				ALUOp = 2'b00;
//				A3Sel = 2'b00;
//				WrRegSel = 2'b00;
//				ALU_AOp = 2'b00;
//				ALU_BOp = 2'b00;
//				EXT_Source = 0;
//			end
//			`LUI:begin
//				NPCOp = 2'b00;
//				GRF_En = 1;
//				EXTOp = 0;
//				ALUOp = 2'b11;
//				WDM_En = 0;
//				A3Sel = 2'b00;
//				WrRegSel = 2'b00;
//				ALU_AOp = 2'b01;
//				ALU_BOp = 2'b10;
//				EXT_Source = 0;
//			end
//			`JAL:begin
//				NPCOp = 2'b10;
//				GRF_En = 1;
//				WDM_En = 0;
//				A3Sel = 2'b10;
//				WrRegSel = 2'b10;
//				EXTOp = 0;
//				ALUOp = 2'b00;
//				ALU_AOp = 2'b00;
//				ALU_BOp = 2'b00;
//				EXT_Source = 0;
//			end
//			`JR:begin
//				NPCOp = 2'b11;
//				GRF_En = 0;
//				WDM_En = 0;
//				EXTOp = 0;
//				ALUOp = 2'b00;
//				A3Sel = 2'b00;
//				WrRegSel = 2'b00;
//				ALU_AOp = 2'b00;
//				ALU_BOp = 2'b00;
//				EXT_Source = 0;
//			end
//			`SLL:begin
//				NPCOp = 2'b00;
//				GRF_En = 1;
//				EXTOp = 0;
//				ALUOp = 2'b11;
//				WDM_En = 0;
//				A3Sel = 2'b01;
//				WrRegSel = 2'b00;
//				ALU_AOp = 2'b10;
//				ALU_BOp = 2'b01;
//				EXT_Source = 1;
//			end
//			default:begin
//				NPCOp = 2'b00;
//				GRF_En = 0;
//				ALUOp = 2'b00;
//				WDM_En = 0;
//				A3Sel = 2'b00;
//				WrRegSel = 2'b00;
//				ALU_AOp = 2'b00;
//				ALU_BOp = 2'b00;
//				EXTOp = 0;
//				EXT_Source = 0;
//			end
//			//以上所有的x按照0处理
//		endcase
//	end



//	assign NPCOp = ((Opcode==`BEQ)&&(Zero==1'b1))? 2'b01:
//						(Opcode==`JAL)? 2'b10:
//						(total==`JR)? 2'b11:
//													2'b00;
//	assign GRF_En = (total==`ADDU)? 1:
//							(total==`SUBU)? 1:
//							(Opcode==`ORI)? 1:
//							(Opcode==`LW)? 1:
//							(Opcode==`LUI)? 1:
//							(Opcode==`JAL)? 1:
//							(total==`SLL)? 1:
//													0;
//	assign EXTOp = (Opcode==`LW)? 1:
//						(Opcode==`SW)? 1: 0;
//	assign ALUOp = (total==`SUBU)? 2'b01:
//						(Opcode==`ORI)? 2'b10:
//						(Opcode==`LUI)? 2'b11:
//						(total==`SLL)? 2'b11:
//													2'b00;
//	assign WDM_En = (Opcode==`SW)? 1: 0;
//	assign A3Sel = (total==`ADDU)? 2'b01:
//						(total==`SUBU)? 2'b01:
//						(Opcode==`JAL)? 2'b10:
//						(total==`SLL)? 2'b01:
//													2'b00;
//	assign WrRegSel = (Opcode==`LW)? 2'b01:
//							(Opcode==`JAL)? 2'b10:
//														2'b00;
//	assign ALU_AOp = (Opcode==`LUI)? 2'b01:
//							(total==`SLL)? 2'b10: 
//														2'b00;
//	assign ALU_BOp = (Opcode==`ORI)? 2'b01:
//							(Opcode==`LW)? 2'b01:
//							(Opcode==`SW)? 2'b01:
//							(Opcode==`LUI)? 2'b10:
//							(total==`SLL)? 2'b01:
//														2'b00;
//	assign EXT_Source = (total==`SLL)? 1: 0;

endmodule
