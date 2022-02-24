`timescale 1ns / 1ps
`include "MACRO.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:43:08 12/02/2020 
// Design Name: 
// Module Name:    Tuse 
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
module Tuse(
	input[31:0] Instr,
	output Tuse_RS0,
	output Tuse_RS1,
	output Tuse_RT0,
	output Tuse_RT1,
	output Tuse_RT2
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
	//////////////////////////////
	assign Tuse_RS0 = BEQ + BNE + BLEZ + BGTZ + BLTZ + BGEZ + JR + JALR;
	assign Tuse_RS1 = ADDU + SUBU + ADD + SUB + AND + OR + XOR + NOR 
							+ SLT + SLTU + ADDIU + ADDI + ANDI + XORI + ORI 
							+ SLTI + SLTIU + SLLV + SRLV + SRAV + LW + LB 
							+ LBU + LH + LHU + SW + SB + SH + MULT + MULTU 
							+ DIV + DIVU + MTHI + MTLO;
	
	assign Tuse_RT0 = BEQ + BNE + BLEZ + BGTZ + BLTZ + BGEZ;
	assign Tuse_RT1 = ADDU + SUBU + ADD + SUB + AND + OR 
							+ XOR + NOR + SLT + SLTU + SLL + SRL 
							+ SRA + SLLV + SRLV + SRAV 
							+ MULT + MULTU + DIV + DIVU
							+ MTC0;
	assign Tuse_RT2 = SW + SB + SH;

endmodule
