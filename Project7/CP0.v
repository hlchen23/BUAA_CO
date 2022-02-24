`timescale 1ns / 1ps
`define Int    5'b00000
`define AdEL   5'b00100
`define AdES   5'b00101
`define RI     5'b01010
`define Ov     5'b01100

`define SR     5'b01100
`define Cause  5'b01101
`define EPC    5'b01110
`define PRId   5'b01111
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:52:50 12/17/2020 
// Design Name: 
// Module Name:    CP0 
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
module CP0(
	input[4:0] A_RD,
	input[4:0] A_WR,
	input[31:0] WD,
	output[31:0] RD,
	input We,
	input[31:0] PC,
	input[5:0] HWInt,
	input[6:2] ExcCode_,
	output reg[31:0] EPC,
	//input[15:10] IP,
	output IntReq,
	input Clk,
	input Rst,
	input BD_,
	input ActivateCP0,
	input CoolCP0
    );

	reg[15:10] IM;
	reg EXL;//[1]
	reg IE;//[0]
	reg BD;//[31]
	reg[15:10] IP;
	reg[6:2] ExcCode;
	
	reg[31:0] PRId;
	wire[31:0] SR;
	assign SR = {16'b0,IM,8'b0,EXL,IE};
	wire[31:0] Cause;
	assign Cause = {BD,15'b0,IP,3'b0,ExcCode,2'b0};
//	assign Cause = {BD,15'b0,HWInt,3'b0,ExcCode,2'b0};用于读Cause寄存器需要内部转发的情况
	//PRId
	always@(posedge Clk)begin
		if(Rst)begin
			PRId <= 32'b0;
		end
	end
	//SR IE/IM
	always@(posedge Clk)begin
		if(Rst)begin
			IM <= 6'b000000;
			IE <= 1'b0;
		end
		else begin
			if(We)begin
				if(A_WR==`SR)begin
					IM <= WD[15:10];
					IE <= WD[0];
				end
			end
		end
	end
	//SR EXL
	always@(posedge Clk)begin
		if(Rst)begin
			EXL <= 1'b0;
		end
		else begin
			if(We)begin//We,Activate,Cool作为E级信号
				if(A_WR==`SR)begin
					EXL <= WD[1];
				end
			end
			else if(ActivateCP0)begin
				EXL <= 1'b1;
			end
			else if(CoolCP0)begin
				EXL <= 1'b0;
			end
		end
	end
	//EPC
	always@(posedge Clk)begin
		if(Rst)begin
			EPC <= 32'b0;
		end
		else begin
			if(We)begin
				if(A_WR==`EPC)begin
					EPC <= {WD[31:2],2'b0};//进行了字对齐软件写入的修改
				end
			end
			else if(ActivateCP0)begin
				EPC <= {PC[31:2],2'b0};
			end
		end
	end
	//Cause
	always@(posedge Clk)begin
		if(Rst)begin
			IP <= 6'b0;
			ExcCode <= 5'b0;
			BD <= 1'b0;
		end
		else begin
			IP <= HWInt;
			if(ActivateCP0)begin
				ExcCode <= ExcCode_;
				BD <= BD_;
			end
		end
	end
	
	assign RD = (A_RD==`SR)? SR:
					(A_RD==`Cause)? Cause:
					(A_RD==`EPC)? EPC:
					(A_RD==`PRId)? PRId:
												32'b0;
	assign IntReq = (IE && (~EXL) && (|(IM & HWInt)));
	
											
endmodule
