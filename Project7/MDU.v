`timescale 1ns / 1ps
`include "MACRO.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:10:43 12/09/2020 
// Design Name: 
// Module Name:    MDU 
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
module MDU(
	input[31:0] MDU_D1,
	input[31:0] MDU_D2,
	input[31:0] WrHL,
	input HI_En,
	input LO_En,
	input[1:0] MDU_Sel,
	input Start,
	input Clk,
	input Rst,
	input HaveIntOrExc,
	output[31:0] R_HI,
	output[31:0] R_LO,
	output Busy
    );
	reg[31:0] HI_tmp;
	reg[31:0] LO_tmp;
	reg[31:0] HI;
	reg[31:0] LO;
	reg[31:0] count;
	wire[63:0] signed_multiply;
	wire[31:0] signed_quotient;//商
	wire[31:0] signed_remainder;//余数
	wire[63:0] unsigned_multiply;
	wire[31:0] unsigned_quotient;//商
	wire[31:0] unsigned_remainder;//余数
	
	assign signed_multiply = $signed(MDU_D1) * $signed(MDU_D2);
	assign signed_quotient = $signed(MDU_D1) / $signed(MDU_D2);
	assign signed_remainder = $signed(MDU_D1) % $signed(MDU_D2);
	assign unsigned_multiply = {1'b0,MDU_D1} * {1'b0,MDU_D2};
	assign unsigned_quotient = {1'b0,MDU_D1} / {1'b0,MDU_D2};
	assign unsigned_remainder = {1'b0,MDU_D1} % {1'b0,MDU_D2};
	
	
	always@(posedge Clk)begin
		if(Rst)begin
			count <= 0;
			HI <= 0;
			LO <= 0;
			HI_tmp <= 0;
			LO_tmp <= 0;
		end
		else begin
			if(Start)begin
//			if((Start)&&(~HaveIntOrExc))begin
				if((MDU_Sel==`MULT_)||(MDU_Sel==`MULTU_))begin
					count <= 5;
					case(MDU_Sel)
						`MULT_:begin
							HI_tmp <= signed_multiply[63:32];
							LO_tmp <= signed_multiply[31:0];
						end
						`MULTU_:begin
							HI_tmp <= unsigned_multiply[63:32];
							LO_tmp <= unsigned_multiply[31:0];
						end
					endcase
				end
				else if((MDU_Sel==`DIV_)||(MDU_Sel==`DIVU_))begin
					count <= 10;
					case(MDU_Sel)
						`DIV_:begin
							HI_tmp <= signed_remainder;
							LO_tmp <= signed_quotient;
						end
						`DIVU_:begin
							HI_tmp <= unsigned_remainder;
							LO_tmp <= unsigned_quotient;
						end
					endcase
				end
			end
			
			if($signed(count)>0)begin
				count <= count - 1;
			end
			if($signed(count)==1)begin
				HI <= HI_tmp;
				LO <= LO_tmp;
			end
			
			if(HI_En)begin
				HI <= WrHL;
			end
			else if(LO_En)begin
				LO <= WrHL;
			end
			
		end
	end
	
	assign Busy = ($signed(count)>0);
	assign R_HI = HI;
	assign R_LO = LO;
endmodule
