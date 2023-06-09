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
    input [31:0] npc,
    output [31:0] instr,
    output [31:0] pc,
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd,
    output [15:0] imm,
    output [25:0] imm26,
    output [5:0] OP,
    output [5:0] Func
    );
	 
	 reg [31:0] im [0:1023];
	 reg [31:0] PC;
	 
	 initial begin
	 PC <= 32'h0000_3000;
    $readmemh("code.txt", im);
	 end
	 
	 always@(posedge clk) begin
	 if(reset == 1) begin
	 PC <= 32'h0000_3000;
	 end
	 else begin
	 PC <= npc;
	 end
	 end
	 
	 assign instr = im[pc[11:2]];
	 assign OP = instr[31:26];
	 assign rs = instr[25:21];
	 assign rt = instr[20:16];
	 assign rd = instr[15:11];
	 assign imm = instr[15:0];
	 assign imm26 = instr[25:0];
	 assign Func = instr[5:0];
	 assign pc = PC;


endmodule
