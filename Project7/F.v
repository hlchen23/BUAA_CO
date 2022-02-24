`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:32:51 12/02/2020 
// Design Name: 
// Module Name:    F 
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
module F(
	input Stall,
	input[15:0] Imm16,
	input[25:0] Imm26,
	input[31:0] Reg,
	input[31:0] EPC,
	input ActivateCP0,
	input CoolCP0,
	input[2:0] NPCOp_ID,
	input Rst,
	input Clk,
	output[31:0] Instr,
	output[31:0] PC8_Out,
	output reg[31:0] PC
    );
	
	wire[31:0] N_PC;
	NPC NPC1(
			.Stall(Stall),
			.PC(PC),
			.Imm16(Imm16),
			.Imm26(Imm26),
			.Reg(Reg),
			.EPC(EPC),
			.ActivateCP0(ActivateCP0),
			.CoolCP0(CoolCP0),
			.NPCOp(NPCOp_ID),
			.N_PC(N_PC),
			.PC8_Out(PC8_Out)
			);

always@(posedge Clk)begin
	if (Rst) begin
		PC <= 32'h00003000;
	end
	else begin
		PC <= N_PC;
	end
end

	IM IM(.IM_Addr(PC),.Instr(Instr));
	Ctrl Ctrl(
			.Instr(),
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
			.IsMD(),
			.MDU_Out_Sel(),
			.HI_En(),
			.LO_En(),
			.BE_LOCATE_Op(),
			.DM_VALUE_Op(),
			.MDU_Sel()
			);	

endmodule
