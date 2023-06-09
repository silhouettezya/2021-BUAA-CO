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
module DM(
    input [31:0] pc,
    input clk,
    input reset,
    input [31:0] DMaddr,
    input [31:0] DMdata,
    input MEMwrite,
    input [1:0] Dmtype,
    output [31:0] DMout
    );
	 
	 reg [31:0] dm [1023:0];
	 
	 wire [31:0] data;
	 wire [9:0] waddr;
	 
	 integer i;
	 
	 initial begin
	 for(i=0;i<1024;i=i+1) dm[i] <= 0;
	 end
	 
	 always@(posedge clk) begin
	 if(reset == 1) begin
	 for(i=0;i<1024;i=i+1) dm[i] <= 0;
	 end
	 
	 else if(MEMwrite == 1) begin
	 dm[waddr] <= DMdata;
	 $display("@%h: *%h <= %h", pc, DMaddr, DMdata);
	 end
	 end
	 
	 assign waddr = DMaddr[11:2];
	 assign data = dm[waddr];
	 assign DMout = (Dmtype == `dm_word)? data:
	                                       data;
	 


endmodule
