`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:41:01 12/02/2020 
// Design Name: 
// Module Name:    W 
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
module W(
	input[31:0] Instr,
	input[31:0] ALU_Out,
	input[31:0] DM_Out,
	input[31:0] PC4_Out,
	input[31:0] PC,
	input[4:0] Rx,
	input Clk,
	input Rst
    );
	wire GRF_En;
	wire[31:0] WrReg;
	wire[1:0] WrRegSel;
	
	GRF GRF(
			.A1(),
			.A2(),
			.A3(Rx),
			.WrReg(WrReg),
			.GRF_En(GRF_En),
			.Clk(Clk),
			.Rst(Rst),
			.RD1(),
			.RD2(),
			.PC(PC)
			);
	MUX_WrRegSel MUX_WrRegSel(
				.ALU_Out(ALU_Out),
				.DM_Out(DM_Out),
				.PC4_Out(PC4_Out),
				.WrRegSel(WrRegSel),
				.Out(WrReg)
				);
	Ctrl Ctrl(
			.Instr(Instr),
			.Zero(),
			.NPCOp(),
			.GRF_En(GRF_En),
			.EXTOp(),
			.ALUOp(),
			.WDM_En(),
			.A3Sel(),
			.WrRegSel(WrRegSel),
			.ALU_AOp(),
			.ALU_BOp(),
			.EXT_Source()
			);
endmodule
