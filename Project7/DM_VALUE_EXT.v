`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:19:49 12/09/2020 
// Design Name: 
// Module Name:    DM_VALUE_EXT 
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
module DM_VALUE_EXT(
	input[31:0] DM_Addr,
	input[31:0] DM_EXT_In,
	input[2:0]  DM_VALUE_Op,
	output[31:0] DM_True_Out
    );
	 wire[31:0] signed_H;
	 wire[31:0] unsigned_H;
	 wire[31:0] signed_B;
	 wire[31:0] unsigned_B;
	 assign unsigned_H = (DM_Addr[1]==1'b0)? {16'b0,DM_EXT_In[15:0]}: {16'b0,DM_EXT_In[31:16]};
	 assign   signed_H = (DM_Addr[1]==1'b0)? {{16{DM_EXT_In[15]}},DM_EXT_In[15:0]}: {{16{DM_EXT_In[31]}},DM_EXT_In[31:16]};
	 assign unsigned_B = (DM_Addr[1:0]==2'b00)? {24'b0,DM_EXT_In[7:0]}: 
								(DM_Addr[1:0]==2'b01)? {24'b0,DM_EXT_In[15:8]}:
								(DM_Addr[1:0]==2'b10)? {24'b0,DM_EXT_In[23:16]}:
																{24'b0,DM_EXT_In[31:24]};
	 assign   signed_B = (DM_Addr[1:0]==2'b00)? {{24{DM_EXT_In[7]}},DM_EXT_In[7:0]}: 
								(DM_Addr[1:0]==2'b01)? {{24{DM_EXT_In[15]}},DM_EXT_In[15:8]}:
								(DM_Addr[1:0]==2'b10)? {{24{DM_EXT_In[23]}},DM_EXT_In[23:16]}:
																{{24{DM_EXT_In[31]}},DM_EXT_In[31:24]};
	assign DM_True_Out = (DM_VALUE_Op==3'b000)? DM_EXT_In://LW
								(DM_VALUE_Op==3'b001)? unsigned_B://LBU
								(DM_VALUE_Op==3'b010)? signed_B://LB
								(DM_VALUE_Op==3'b011)? unsigned_H://LHU
								(DM_VALUE_Op==3'b100)? signed_H://LH
								                                DM_EXT_In;//default:LW

endmodule
