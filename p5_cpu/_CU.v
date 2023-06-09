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
module _CU(
	 input [31:0] instr,
    // decode
    output [4:0] rs_addr,
    output [4:0] rt_addr,
    output [4:0] rd_addr,
    output [15:0] imm,
    output [25:0] imm26,
	 // codetype
	 output load,
    output store,
    output calc_r,
    output calc_i,
	 output j_r,
	 output j_br,
	 // control signal
	 // Dcon
	 output [2:0] Branch,
	 output [2:0] EXTop,
	 // Econ
	 output [3:0] ALUcon,
	 output ALUsel,
	 // Mcon
	 output MEMwrite,
    output [2:0] DMtype,
	 // Wcon
	 output GRFwrite,
	 output [2:0]WDsel,
	 output [2:0] REGsel,
	 // dst
	 output [4:0] A3dst
    );
	 
	 // decode
	 wire [5:0] OP, Func;
	 
	 assign OP = instr[31:26];
    assign Func = instr[5:0];
    assign rs_addr = instr[25:21];
    assign rt_addr = instr[20:16];
    assign rd_addr = instr[15:11];
    assign imm = instr[15:0];
    assign imm26 = instr[25:0];
	 
	 // instr type
	 wire addu, subu, ori, lw, sw, beq, lui, jal, jr, slt,j;
	 
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
	 assign j = (OP == `OP_j);
	 
	 // code type
	 assign load = lw;
	 assign store = sw;
	 assign calc_r = (addu || subu || slt);
	 assign calc_i = (ori || lui);
	 assign j_r = jr;
	 assign j_br = beq;
	 
	 
	 //control signal
	 
	 assign MEMwrite = (sw);
	 assign WDsel = (lw)? `wd_mem:
	                (jal)? `wd_pc4:
						        `wd_alu;
	 assign ALUsel = (ori || lw || sw || lui);
	 assign GRFwrite = (addu || subu || ori || lw || lui || jal || slt);
	 assign EXTop = (lw || sw) ? `ext_signed:
	                (ori || lui) ? `ext_unsigned:
						         `ext_unsigned;
	 assign Branch = (beq) ? `br_beq:
	                 (jal || j) ? `br_jal:
						  (jr) ? `br_jr:
						         `br_pc;
									
	 assign REGsel = (addu || subu) ? `reg_rd:
	                 (jal) ? `reg_31:
						  (ori || lui || lw) ? `reg_rt:
						             3'b011;
									 
	 assign ALUcon = (addu) ? `ALU_add:
	                     (subu) ? `ALU_sub:
								(ori) ? `ALU_or:
								(slt) ? `ALU_slt:
								(lui) ? `ALU_lui:
								        `ALU_add;
										  
	 assign DMtype = (lw || sw) ? `dm_word:
	                              `dm_word;
									
	 assign A3dst = (REGsel == `reg_rt) ? rt_addr:
	                (REGsel == `reg_rd) ? rd_addr:
		             (REGsel == `reg_31) ? 5'b11111:
		                                        5'b0;
										  
								
	 
	 
	 
	 


endmodule
