`timescale 1ns / 1ps
`include "MACRO.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:27:59 12/02/2020 
// Design Name: 
// Module Name:    MUX 
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
module MUX_EXT_Source(
	input[15:0] Imm16,
	input[4:0] Offset,
	input EXT_Source,
	output[15:0] Out
    );
	assign Out = (EXT_Source==0)? Imm16: {{11{1'b0}},Offset};

endmodule

module MUX_A3Sel(
	input[4:0] Rt,
	input[4:0] Rd,
	//常数不再写
	input[1:0] A3Sel,
	output[4:0] Out
    );
	 
	assign Out = (A3Sel==2'b00)? Rt:
					(A3Sel==2'b01)? Rd:
					(A3Sel==2'b10)? 5'b11111: 
										5'b0;

endmodule

module MUX_WrRegSel(
	input[31:0] ALU_Out,
	input[31:0] DM_Out,
	input[31:0] PC8_Out,
	input[31:0] MDU_Out,
	input[31:0] CP0_Out,
	input[2:0] WrRegSel,
	output[31:0] Out
    );
	assign Out = (WrRegSel==3'b000)? ALU_Out:
						(WrRegSel==3'b001)?DM_Out:
						(WrRegSel==3'b010)?PC8_Out:
						(WrRegSel==3'b011)?MDU_Out:
						(WrRegSel==3'b100)?CP0_Out:
												         ALU_Out;

endmodule

module MUX_ALU_AOp(
	input[31:0] GRF_RD1,
	input[31:0] EXT_Out,
	input[1:0] ALU_AOp,
	output[31:0] Out
    );
	assign Out = (ALU_AOp==2'b00)? GRF_RD1:
						(ALU_AOp==2'b01)?EXT_Out:
												32'b0;

endmodule

module MUX_ALU_BOp(
	input[31:0] GRF_RD2,
	input[31:0] EXT_Out,
	input[1:0] ALU_BOp,
	output[31:0] Out
    );
	assign Out = (ALU_BOp==2'b00)? GRF_RD2:
						(ALU_BOp==2'b01)?EXT_Out:
												32'b0;

endmodule

module MUX_MDU_Out_Sel(
	input[31:0] HI,
	input[31:0] LO,
	input MDU_Out_Sel,
	output[31:0] MDU_Out
	);
	
	assign MDU_Out = (MDU_Out_Sel==1'b0)? HI: LO;
	
endmodule

////////////////////////////////////////////////////
//转发相关
module MUX_F_VALUE_WB(
	input[31:0] ALU,
	input[31:0] DM,
	input[31:0] IFU,
	input[31:0] MDU,
	input[31:0] CP0,
	input[2:0] F_VALUE_WB_SEL,
	output[31:0] F_VALUE_WB
	);
	
	assign F_VALUE_WB = (F_VALUE_WB_SEL==3'b000)? ALU:
								(F_VALUE_WB_SEL==3'b001)? DM:
								(F_VALUE_WB_SEL==3'b010)? IFU:
								(F_VALUE_WB_SEL==3'b011)? MDU:
								(F_VALUE_WB_SEL==3'b100)? CP0:
																		ALU;
endmodule

module MUX_F_VALUE_MEM(
	input[31:0] ALU,
	input[31:0] IFU,
	input[31:0] MDU,
	input[31:0] CP0,
	input[1:0] F_VALUE_MEM_SEL,
	output[31:0] F_VALUE_MEM
	);
	
	assign F_VALUE_MEM = (F_VALUE_MEM_SEL==2'b00)? ALU:
								(F_VALUE_MEM_SEL==2'b01)? IFU:
								(F_VALUE_MEM_SEL==2'b10)? MDU:
								(F_VALUE_MEM_SEL==2'b11)? CP0:
																		ALU;
endmodule
///////////////////////////////////////////////////////

//以下多余
//module MUX_F_ALU_B_RD2EX(
//	input[31:0] F_VALUE_MEM,
//	input[31:0] F_VALUE_WB,
//	input[31:0] RD2_EX,
//	input[1:0] MUX_F_ALU_B_RD2EX_SEL,
//	output[31:0] RD2_EX_NEW
//	);
//	
//	assign RD2_EX_NEW = (MUX_F_ALU_B_RD2EX_SEL==`M_RD2_EX)? F_VALUE_MEM:
//							  (MUX_F_ALU_B_RD2EX_SEL==`W_RD2_EX)? F_VALUE_WB:
//																							RD2_EX;
//endmodule
//
//module MUX_F_ALU_A_RD1EX(
//	input[31:0] F_VALUE_MEM,
//	input[31:0] F_VALUE_WB,
//	input[31:0] RD1_EX,
//	input[1:0] MUX_F_ALU_A_RD1EX_SEL,
//	output[31:0] RD1_EX_NEW
//	);
//	
//	assign RD1_EX_NEW = (MUX_F_ALU_A_RD1EX_SEL==`M_RD1_EX)? F_VALUE_MEM:
//							  (MUX_F_ALU_A_RD1EX_SEL==`W_RD1_EX)? F_VALUE_WB:
//																							RD1_EX;
//endmodule
//
//module MUX_F_ALU_A_RD2EX(
//	input[31:0] F_VALUE_MEM,
//	input[31:0] F_VALUE_WB,
//	input[31:0] RD2_EX,
//	input[1:0] MUX_F_ALU_A_RD2EX_SEL,
//	output[31:0] RD2_EX_NEW
//	);
//	
//	assign RD2_EX_NEW = (MUX_F_ALU_A_RD2EX_SEL==`M_RD2_EX)? F_VALUE_MEM:
//							  (MUX_F_ALU_A_RD2EX_SEL==`W_RD2_EX)? F_VALUE_WB:
//																							RD2_EX;
//endmodule
//
//module MUX_F_DM_WrDM_MEM(
//	input[31:0] F_VALUE_WB,
//	input RD2_MEM,
//	input MUX_F_DM_WrDM_MEM_SEL,
//	output[31:0] WrDM_NEW
//	);
//	
//	assign WrDM_NEW = (MUX_F_DM_WrDM_MEM_SEL==`W_DM_WrDM_M)? F_VALUE_WB: RD2_MEM;
//
//endmodule
//
//module MUX_F_IFU_Reg(
//	input[31:0] F_VALUE_EX,
//	input[31:0] F_VALUE_MEM,
//	input[31:0] F_VALUE_WB,
//	input[31:0] RD1_ID,
//	input[1:0] MUX_F_IFU_Reg_SEL,
//	output[31:0] Reg_NEW
//	);
//	assign Reg_NEW = (MUX_F_IFU_Reg_SEL==`E_IFU_Reg)? F_VALUE_EX:
//							(MUX_F_IFU_Reg_SEL==`M_IFU_Reg)? F_VALUE_MEM:
//							(MUX_F_IFU_Reg_SEL==`W_IFU_Reg)? F_VALUE_WB:
//																						RD1_ID;
//endmodule 
//
//module MUX_F_COMP_COMP1(
//	input[31:0] F_VALUE_EX,
//	input[31:0] F_VALUE_MEM,
//	input[31:0] F_VALUE_WB,
//	input[31:0] RD1_ID,
//	input[1:0] MUX_F_COMP_COMP1_SEL,
//	output[31:0] COMP1_NEW
//	);
//	
//	assign COMP1_NEW = (MUX_F_COMP_COMP1_SEL==`E_COMP_COMP1)? F_VALUE_EX:
//							 (MUX_F_COMP_COMP1_SEL==`M_COMP_COMP1)? F_VALUE_MEM:
//							 (MUX_F_COMP_COMP1_SEL==`W_COMP_COMP1)? F_VALUE_WB:
//																								RD1_ID;
//
//endmodule
//
//module MUX_F_COMP_COMP2(
//	input[31:0] F_VALUE_EX,
//	input[31:0] F_VALUE_MEM,
//	input[31:0] F_VALUE_WB,
//	input[31:0] RD2_ID,
//	input[1:0] MUX_F_COMP_COMP2_SEL,
//	output[31:0] COMP2_NEW
//	);
//	
//	assign COMP2_NEW = (MUX_F_COMP_COMP2_SEL==`E_COMP_COMP2)? F_VALUE_EX:
//							 (MUX_F_COMP_COMP2_SEL==`M_COMP_COMP2)? F_VALUE_MEM:
//							 (MUX_F_COMP_COMP2_SEL==`W_COMP_COMP2)? F_VALUE_WB:
//																								RD2_ID;
//
//endmodule

