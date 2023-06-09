`timescale 1ns / 1ps
`include "const.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:00:08 11/14/2021 
// Design Name: 
// Module Name:    Control_Unit 
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
module Control_Unit(
    input [5:0]OP,
    input [5:0]Func,
    output [2:0]WDsel,
    output MEMwrite,
	 output ALUsel,
    output REGwrite,
	 output ext,
	 output [2:0] Branch,
    output [2:0] REGsel,
    output [3:0] ALUcon,
    output [1:0] Dmtype
    );
	 
	 wire addu, subu, ori, lw, sw, beq, lui, jal, jr, slt;
	 
	 wire rtype;
	 
	 assign rtype = (OP == `OP_rtype);
	 assign addu = ((rtype) && (Func == `FUNC_addu));
	 assign subu = ((rtype) && (Func == `FUNC_subu));
	 assign ori = (OP == `OP_ori);
	 assign lw = (OP == `OP_lw);
	 assign sw = (OP == `OP_sw);
	 assign beq = (OP == `OP_beq);
	 assign lui = (OP == `OP_lui);
	 assign jal = (OP == `OP_jal);
	 assign jr = ((rtype) && (Func == `FUNC_jr));
	 assign slt = ((rtype) && (Func == `FUNC_slt));
	 
	 assign MEMwrite = (sw);
	 assign WDsel = (lw)? `wd_mem:
	                (jal)? `wd_pc4:
						        `wd_alu;
	 assign ALUsel = (ori || lw || sw || lui);
	 assign REGwrite = (addu || subu || ori || lw || lui || jal || slt);
	 assign ext = (lw || sw);
	 assign Branch = (beq) ? `br_beq:
	                 (jal) ? `br_jal:
						  (jr) ? `br_jr:
						         `br_pc;
									
	 assign REGsel = (addu || subu) ? `reg_rd:
	                 (jal) ? `reg_31:
						          `reg_rt;
									 
	 assign ALUcon = (addu) ? `ALU_add:
	                     (subu) ? `ALU_sub:
								(ori) ? `ALU_or:
								(slt) ? `ALU_slt:
								(lui) ? `ALU_lui:
								        `ALU_add;
										  
	 assign Dmtype = (sw) ? `dm_word:
	                        `dm_word;
										  
								
	 
	 
	 
	 


endmodule
