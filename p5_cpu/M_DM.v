`timescale 1ns / 1ps
`include "const.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:25:09 11/14/2021 
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
module M_DM(
    input [31:0] pc,
    input clk,
    input reset,
    input [31:0] DMaddr,
    input [31:0] DMdata,
    input WE,
    input [2:0] DMtype,
    output [31:0] DMout
    );
	 
	 reg [31:0] dm [3071:0];
	 
	 wire [31:0] word, hword, bword;
	 wire [31:0] s_word, s_hword, s_bword;
	 wire [11:0] waddr;
	 
	 integer i;
	 
	 initial begin
	 for(i=0;i<3072;i=i+1) dm[i] <= 0;
	 end
	 
	 always@(posedge clk) begin
	 if(reset == 1) begin
	 for(i=0;i<3072;i=i+1) dm[i] <= 0;
	 end
	 
	 else if(WE) begin
	 dm[waddr] <= DMdata;
	 $display("%d@%h: *%h <= %h", $time, pc, DMaddr,DMdata);
	 end
	 end
	 
	 assign waddr = DMaddr[13:2];
	 assign word = dm[waddr];
	 assign hword = (DMaddr[1] == 1) ? word[31:16] : word[15:0];
	 assign bword = (DMaddr[0] == 1) ? hword[15:8] : hword[7:0];
	 
	 assign DMout = (DMtype == `dm_word) ? word:
	                (DMtype == `dm_hword_unsigned) ? hword:
						 (DMtype == `dm_hword_signed) ? {{16{hword[15]}},hword[15:0]}:
						 (DMtype == `dm_byte_unsigned) ? bword:
						 (DMtype == `dm_byte_signed) ? {{24{bword[7]}},bword[7:0]}:
	                                      word;
	 


endmodule
