`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:52:52 11/14/2021 
// Design Name: 
// Module Name:    IFU 
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
module IFU(
    input clk,
    input reset,
	 input WE,
    input [31:0] npc,
    output [31:0] instr,
    output [31:0] pc
    );
	 
	 reg [31:0] im [0:4095];
	 reg [31:0] PC;
	 
	 initial begin
	 PC <= 32'h0000_3000;
    $readmemh("code.txt", im);
	 end
	 
	 always@(posedge clk) begin
	 if(reset == 1) begin
	 PC <= 32'h0000_3000;
	 end
	 else if(WE) begin
	 PC <= npc;
	 end
	 end
	 
	 assign instr = im[pc[15:2] - 13'HC00];
	
	 assign pc = PC;


endmodule
