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
	 output shift_s,
	 output shift_v,
	 output j_r,
	 output j_br,
	 output md,
	 output mt,
	 output mf,
	 // control signal
	 // Dcon
	 output [2:0] Branch,
	 output [2:0] B_type,
	 output [2:0] EXTop,
	 // Econ
	 output [3:0] ALUcon,
	 output [1:0] ALUsel1,
	 output [2:0] ALUsel2,
	 output [3:0] HILOtype,
	 // Mcon
	 output [2:0] BEsel,
	 output [2:0] DPsel,
	 // Wcon
	 output GRFwrite,
	 output [2:0]WDsel,
	 output [2:0] REGsel,
	 // dst
	 output [4:0] A3dst,
	 //cp0
	 output cwe,
	 output mfc0,
	 output mtc0,
	 output eret,
	 //exception
	 output EXri,
	 output ALUadsub,
	 output ALUdm
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
	 wire addu, subu, ori, lw, sw, beq, lui, jal, jr, j, lb, lbu, lh, lhu, add, sub, sll, srl, sra, sllv, srlv, srav, And, andi, Or;
	 wire Xor, Nor, addi, addiu, xori, slt, slti, sltu, sltiu, bne, blez, bgtz, bltz, bgez, jalr;
	 wire mult, multu, div, divu, mflo, mfhi, mtlo, mthi, sh, sb;
	 
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
	 assign lb = (OP == `OP_lb);
	 assign lbu = (OP == `OP_lbu);
	 assign lh = (OP == `OP_lh);
	 assign lhu = (OP == `OP_lhu);
	 assign add = ((rtype) && (Func == `FUNC_add));
	 assign sub = ((rtype) && (Func == `FUNC_sub));
	 assign sll = ((rtype) && (Func == `FUNC_sll));
	 assign srl = ((rtype) && (Func == `FUNC_srl));
	 assign sra = ((rtype) && (Func == `FUNC_sra));
	 assign sllv = ((rtype) && (Func == `FUNC_sllv));
	 assign srlv = ((rtype) && (Func == `FUNC_srlv));
	 assign srav = ((rtype) && (Func == `FUNC_srav));
	 assign And = ((rtype) && (Func == `FUNC_and));
	 assign andi = (OP == `OP_andi);
	 assign Or = ((rtype) && (Func == `FUNC_or));
	 assign Xor = ((rtype) && (Func == `FUNC_xor));
	 assign Nor = ((rtype) && (Func == `FUNC_nor));
	 assign addi = (OP == `OP_addi);
	 assign addiu = (OP == `OP_addiu);
	 assign xori = (OP == `OP_xori);
	 assign slti = (OP == `OP_slti);
	 assign sltu = ((rtype) && (Func == `FUNC_sltu));
	 assign sltiu = (OP == `OP_sltiu);
	 assign bne = (OP == `OP_bne);
	 assign blez = (OP == `OP_blez);
	 assign bgtz = (OP == `OP_bgtz);
	 assign bltz = (OP == `OP_bltz) && (rt_addr == `RT_bltz);
	 assign bgez = (OP == `OP_bgez) && (rt_addr == `RT_bgez);
	 assign jalr = ((rtype) && (Func == `FUNC_jalr));
	 assign mult = ((rtype) && (Func == `FUNC_mult));
	 assign multu = ((rtype) && (Func == `FUNC_multu));
	 assign div = ((rtype) && (Func == `FUNC_div));
	 assign divu = ((rtype) && (Func == `FUNC_divu));
	 assign mthi = ((rtype) && (Func == `FUNC_mthi));
	 assign mtlo = ((rtype) && (Func == `FUNC_mtlo));
	 assign mfhi = ((rtype) && (Func == `FUNC_mfhi));
	 assign mflo = ((rtype) && (Func == `FUNC_mflo));
	 assign sh = (OP == `OP_sh);
	 assign sb = (OP == `OP_sb);
	 assign mfc0 = (OP == `OP_cp0) && (rs_addr == `cp0_mfc0)  && (instr[10:0] == 11'b0);
	 assign mtc0 = (OP == `OP_cp0) && (rs_addr == `cp0_mtc0)  && (instr[10:0] == 11'b0);
	 assign eret = (OP == `OP_cp0) && (Func == `FUNC_eret) && (instr[25:6] == 20'b1000_0000_0000_0000_0000);
	 
	 // code type
	 assign load = (lw || lb || lbu || lh || lhu);
	 assign store = (sw || sh || sb);
	 assign calc_r = (addu || subu || slt || add || sub || sll || srl || sra || sllv || srlv || srav || And || Or || Xor || Nor || sltu);
	 assign calc_i = (ori || lui || andi || addi || addiu || xori || slti || sltiu);
	 assign j_r = (jr || jalr);
	 assign j_br = (beq || bne || blez || bgtz || bltz || bgez);
	 assign shift_s = (sll || srl || sra);
	 assign shift_v = (sllv || srlv || srav);
	 assign md = (mult || multu || div || divu);
	 assign mf = (mfhi || mflo);
	 assign mt = (mthi || mtlo);
	 
	 //control signal
	 
	 assign WDsel = (lw || lb || lbu || lh || lhu) ? `wd_mem:
	                (jal || jalr) ? `wd_pc4:
						 (mf) ? `wd_hilo:
						 (mfc0) ? `wd_cp0:
						        `wd_alu;
								  
	 assign ALUsel1 = (sll || srl || sra || sllv || srlv || srav) ? `alu1_rt:
	                          `alu1_rs;
									  
	 assign ALUsel2 = (ori || lw || sw || sh || sb || lui || lb || lbu || lh || lhu || andi || addi || addiu || xori || sltiu || slti) ? `alu2_imm:
	                  (sll || srl || sra) ? `alu2_shamt:
							(sllv || srlv || srav) ? `alu2_rs5:
	                  `alu2_rt;
	 
	 assign EXTop = (lw || lb || lbu || lh || lhu || sw || sh || sb || addi || addiu || slti || sltiu) ? `ext_signed:
	                (ori || lui || andi || xori) ? `ext_unsigned:
						         `ext_unsigned;
									
	 assign Branch = (beq || bne || blez || bgtz || bltz || bgez) ? `br_beq:
	                 (jal || j) ? `br_jal:
						  (jr || jalr) ? `br_jr:
						         `br_pc;
									
	 assign B_type = beq ? `b_beq:
	                 bne ? `b_bne:
						  blez ? `b_blez:
						  bgtz ? `b_bgtz:
						  bltz ? `b_bltz:
						  bgez ? `b_bgez:
						  0;
									 
	 assign ALUcon = (addu || add || addi || addiu) ? `ALU_add:
	                 (subu || sub) ? `ALU_sub:
						  (ori || Or) ? `ALU_or:
						  (slt || slti) ? `ALU_slt:
						  (sltu || sltiu) ? `ALU_sltu:
						  (lui) ? `ALU_lui:
						  (sll || sllv) ? `ALU_sll:
						  (srl || srlv) ? `ALU_srl:
						  (sra || srav) ? `ALU_sra:
						  (And || andi) ? `ALU_and:
						  (Xor || xori) ? `ALU_xor:
						  (Nor) ? `ALU_nor:
								    `ALU_add;
									 
	 assign HILOtype = mult ? `HILO_mult:
	                   multu ? `HILO_multu:
							 div ? `HILO_div:
							 divu ? `HILO_divu:
							 mthi ? `HILO_mthi:
							 mtlo ? `HILO_mtlo:
							 mfhi ? `HILO_mfhi:
							 mflo ? `HILO_mflo:
							 `HILO_none;
										  
	 assign BEsel = sw ? `be_sw:
	                sh ? `be_sh:
						 sb ? `be_sb:
						 `be_none;
	
	 assign DPsel = lw ? `dp_lw:
	                lh ? `dp_lh:
						 lb ? `dp_lb:
						 lhu ? `dp_lhu:
						 lbu ? `dp_lbu:
						 `dp_lw;
									
	 assign GRFwrite = !(!A3dst);
	 
	 assign REGsel = (calc_r || jalr || mf) ? `reg_rd:
	                 (jal) ? `reg_31:
						  (calc_i || load || mfc0) ? `reg_rt:
						             `reg_zero;
	 
	 assign A3dst = (REGsel == `reg_rt) ? rt_addr:
	                (REGsel == `reg_rd) ? rd_addr:
		             (REGsel == `reg_31) ? 5'b11111:
		              5'b0;
	 
	 
	 //exception
	 assign cwe = mtc0;
	 assign EXri = !(addu | subu | ori | lw | sw | beq | lui | jal |
	 jr | j | lb | lbu | lh | lhu | add | sub | sll | srl | sra | sllv | srlv | srav | And | andi | Or |
	 Xor | Nor | addi | addiu | xori | slt | slti | sltu | sltiu | bne | blez | bgtz | bltz | bgez | jalr |
	 mult | multu | div | divu | mflo | mfhi | mtlo | mthi | sh | sb | mfc0 | mtc0 | eret);
										  
	 assign ALUadsub = add | addi | sub;
    assign ALUdm = lb | lbu | lh | lhu | lw | sb | sh | sw;	 
	 
	 
	 
	 


endmodule
