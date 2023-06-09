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
module D_NPC(
    input [31:0] F_pc,
	 input [31:0] D_pc,
    input [2:0] Branch,
	 input brjump,
    input [15:0] imm,
    input [25:0] imm26,
	 input [31:0] RD1,
    output [31:0] npc,
	 //exception
	 input eret,
	 input req,
	 input [31:0] epc
    );
	 
	 
	 assign npc = req ? 32'h0000_4180:
	              eret ? epc + 4:
	              (Branch == `br_pc) ? F_pc + 4:
	              (Branch == `br_jal) ? {D_pc[31:28],imm26,2'b0}:
					  (Branch == `br_jr) ? RD1:
					  ((Branch == `br_beq) && brjump) ? (D_pc + 4 + {{14{imm[15]}},imm,2'b0}):
					                                                            F_pc + 4;


endmodule
