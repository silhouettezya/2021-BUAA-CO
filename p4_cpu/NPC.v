`timescale 1ns / 1ps
`include "const.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:35:01 11/15/2021 
// Design Name: 
// Module Name:    NPC 
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
module NPC(
    input [31:0] pc,
    input [2:0] Branch,
	 input beq,
    input [15:0] imm,
    input [25:0] imm26,
	 input [31:0] RD1,
    output [31:0] npc
    );
	 
	 
	 assign npc = (Branch == `br_pc) ? pc + 4:
	              (Branch == `br_jal) ? {pc[31:28],imm26,2'b0}:
					  (Branch == `br_jr) ? RD1:
					  ((Branch == `br_beq) && beq) ? (pc + 4 + {{14{imm[15]}},imm,2'b0}):
					                                                                       pc + 4;


endmodule
