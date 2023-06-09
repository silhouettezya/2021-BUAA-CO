`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:53:55 12/14/2021 
// Design Name: 
// Module Name:    F_PC 
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
module F_PC(
    input clk,
    input reset,
    input WE,
    input [31:0] npc,
    output [31:0] pc,
	 
	 //exception
	 input req,
	 input eret,
	 input [31:0] epc,
	 output EXadel
    );
	 
	 reg [31:0] pc_tmp;
	 
	 initial begin
	 pc_tmp <= 32'h0000_3000;
	 end
	 
	 always @(posedge clk) begin
	 if(reset) begin
	 pc_tmp <= 32'h0000_3000;
	 end
	 else if(WE || req) begin
	 pc_tmp <= npc;
	 end
	 end
	 
	 assign pc = eret ? epc : pc_tmp;
	 assign EXadel = (pc[1:0] != 2'b0) || (pc < 32'h0000_3000) || (pc > 32'h0000_6fff);
	 


endmodule
