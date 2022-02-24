`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:06:52 12/09/2020 
// Design Name: 
// Module Name:    BE_LOCATE 
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
module BE_LOCATE(
	input[31:0] DM_Addr,
	input[1:0] BE_LOCATE_Op,
	output[3:0] Byte_En
    );
	 wire[1:0] Low;
	 assign Low = DM_Addr[1:0];
	assign Byte_En = (BE_LOCATE_Op==2'b00)? 4'b1111:
							((BE_LOCATE_Op==2'b01)&&(Low[1]==1'b0))? 4'b0011:
							((BE_LOCATE_Op==2'b01)&&(Low[1]==1'b1))? 4'b1100:
							((BE_LOCATE_Op==2'b10)&&(Low==2'b00))?   4'b0001:
							((BE_LOCATE_Op==2'b10)&&(Low==2'b01))?   4'b0010:
							((BE_LOCATE_Op==2'b10)&&(Low==2'b10))?   4'b0100:
	                                               	                   4'b1000;
							                                                 
endmodule
