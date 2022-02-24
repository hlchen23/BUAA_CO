`timescale 1ns / 1ps
`include "MACRO.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:24:48 12/02/2020 
// Design Name: 
// Module Name:    DM 
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
module DM(
	input[31:0] DM_Addr,
	input[31:0] WrDM,
	input[31:0] PC,
	input WDM_En,
	input[3:0] Byte_En,
	input Clk,
	input Rst,
	output [31:0] DM_Out
    );
	reg[31:0] DM_Reg[0:4095];
	integer i;
	always@(posedge Clk)begin
		if (Rst)begin
			for(i = 0;i < 4096;i = i + 1)begin
				DM_Reg[i] <= 0;
			end
		end
		else begin
			if (WDM_En)begin
				case(Byte_En)
					4'b1111:begin
						DM_Reg[DM_Addr[13:2]] <= WrDM;
						$display("%d@%h: *%h <= %h", $time, PC, DM_Addr, WrDM);
						//$display("@%h: *%h <= %h", PC, DM_Addr, WrDM);
					end
					4'b0011:begin
						DM_Reg[DM_Addr[13:2]][15:0] <= WrDM[15:0];
						$display("%d@%h: *%h <= %h", $time, PC, {DM_Addr[31:2],2'b00}, {DM_Reg[DM_Addr[13:2]][31:16],WrDM[15:0]});
						//$display("@%h: *%h <= %h", PC, {DM_Addr[31:2],2'b00}, {DM_Reg[DM_Addr[13:2]][31:16],WrDM[15:0]});
					end
					4'b1100:begin
						DM_Reg[DM_Addr[13:2]][31:16] <= WrDM[15:0];
						$display("%d@%h: *%h <= %h", $time, PC, {DM_Addr[31:2],2'b00}, {WrDM[15:0],DM_Reg[DM_Addr[13:2]][15:0]});
						//$display("@%h: *%h <= %h", PC, {DM_Addr[31:2],2'b00}, {WrDM[15:0],DM_Reg[DM_Addr[13:2]][15:0]});
					end
					4'b0001:begin
						DM_Reg[DM_Addr[13:2]][7:0] <= WrDM[7:0];
						$display("%d@%h: *%h <= %h", $time, PC, {DM_Addr[31:2],2'b00}, {DM_Reg[DM_Addr[13:2]][31:8],WrDM[7:0]});
						//$display("@%h: *%h <= %h", PC, {DM_Addr[31:2],2'b00}, {DM_Reg[DM_Addr[13:2]][31:8],WrDM[7:0]});
					end
					4'b0010:begin
						DM_Reg[DM_Addr[13:2]][15:8] <= WrDM[7:0];
						$display("%d@%h: *%h <= %h", $time, PC, {DM_Addr[31:2],2'b00}, {DM_Reg[DM_Addr[13:2]][31:16],WrDM[7:0],DM_Reg[DM_Addr[13:2]][7:0]});
						//$display("@%h: *%h <= %h", PC, {DM_Addr[31:2],2'b00}, {DM_Reg[DM_Addr[13:2]][31:16],WrDM[7:0],DM_Reg[DM_Addr[13:2]][7:0]});
					end
					4'b0100:begin
						DM_Reg[DM_Addr[13:2]][23:16] <= WrDM[7:0];
						$display("%d@%h: *%h <= %h", $time, PC, {DM_Addr[31:2],2'b00}, {DM_Reg[DM_Addr[13:2]][31:24],WrDM[7:0],DM_Reg[DM_Addr[13:2]][15:0]});
						//$display("@%h: *%h <= %h", PC, {DM_Addr[31:2],2'b00}, {DM_Reg[DM_Addr[13:2]][31:24],WrDM[7:0],DM_Reg[DM_Addr[13:2]][15:0]});
					end
					4'b1000:begin
						DM_Reg[DM_Addr[13:2]][31:24] <= WrDM[7:0];
						$display("%d@%h: *%h <= %h", $time, PC, {DM_Addr[31:2],2'b00}, {WrDM[7:0],DM_Reg[DM_Addr[13:2]][23:0]});
						//$display("@%h: *%h <= %h" ,PC, {DM_Addr[31:2],2'b00}, {WrDM[7:0],DM_Reg[DM_Addr[13:2]][23:0]});
					end
				endcase
			end
		end
	end
	
	assign DM_Out = DM_Reg[DM_Addr[13:2]];
	
endmodule
