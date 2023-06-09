`timescale 1ns / 1ps
`include "const.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:34:33 11/23/2021 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
    input reset
    );
	 // stallcontrol
	 wire stall;
	 wire F_pc_en, D_reg_en, E_reg_en, M_reg_en, W_reg_en; // Reg En
	 wire E_reg_reset;
	 
	 assign F_pc_en = !stall;
	 assign D_reg_en = !stall;
	 assign E_reg_en = 1;
	 assign M_reg_en = 1;
	 assign W_reg_en = 1;
	 
	 assign E_reg_reset = stall;
	 
	 wire [31:0] F_instr, D_instr, E_instr, M_instr, W_instr;
	 SU su(
	 .D_instr(D_instr),
    .E_instr(E_instr),
    .M_instr(M_instr),
    .stall(stall)
    );
	 
	 // mux_WD
	 wire [31:0] E_WD, M_WD, W_WD;
	 wire [4:0] E_A3dst, M_A3dst, W_A3dst;
	 wire [2:0] E_WDsel, M_WDsel, W_WDsel;
	 assign E_WD = //(E_WDsel == `wd_mem) ? E_DMout:
	               //(E_WDsel == `wd_alu) ? E_ALUout:
		            (E_WDsel == `wd_pc4) ? E_pc + 8:
	                                      0;
	 assign M_WD = //(M_WDsel == `wd_mem) ? M_DMout:
	               (M_WDsel == `wd_alu) ? M_ALUout:
		            (M_WDsel == `wd_pc4) ? M_pc + 8:
	                                      0;
	 assign W_WD = (W_WDsel == `wd_mem) ? W_DMout:
	               (W_WDsel == `wd_alu) ? W_ALUout:
		            (W_WDsel == `wd_pc4) ? W_pc + 8:
	                                      0;									  
    
	 // stageF
    wire [31:0] F_pc, npc;
	 IFU F_ifu(
    .clk(clk),
    .reset(reset),
    .WE(F_pc_en),
    .npc(npc),
    .instr(F_instr),
    .pc(F_pc)
    );
	 
	 // stageD
	 wire [31:0] D_pc;
    D_REG D_reg (
    .clk(clk),
    .reset(reset),
    .WE(D_reg_en),
    .instr_in(F_instr),
    .pc_in(F_pc),
    .instr_out(D_instr),
    .pc_out(D_pc)
    );
	 
	 wire [4:0] D_rs_addr, D_rt_addr;
	 wire [15:0] D_imm;
	 wire [25:0] D_imm26;
	 wire [2:0] D_Branch;
	 wire [2:0] D_EXTop;
	 _CU D_cu (
    .instr(D_instr), 
    .rs_addr(D_rs_addr), 
    .rt_addr(D_rt_addr),  
    .imm(D_imm), 
    .imm26(D_imm26), 
    .Branch(D_Branch), 
    .EXTop(D_EXTop)
    );
	 
	 wire [31:0] D_EXTout;
	 D_EXT D_ext (
    .imm(D_imm), 
    .EXTop(D_EXTop), 
    .EXTout(D_EXTout)
    );
	 
	 wire [31:0] W_pc, D_rs, D_rt;
	 D_GRF D_grf (
    .W_pc(W_pc), 
    .clk(clk), 
    .reset(reset), 
    .WE(W_GRFwrite), 
    .A1(D_rs_addr), 
    .A2(D_rt_addr), 
    .A3(W_A3dst), 
    .WD(W_WD), 
    .RD1(D_rs), 
    .RD2(D_rt)
    );

	 
	 wire brjump;
	 wire [31:0] D_RS, D_RT;
	 D_CMP D_cmp (
    .in1(D_RS), 
    .in2(D_RT), 
    .brjump(brjump)
    );
	 
    D_NPC D_npc (
    .F_pc(F_pc), 
    .D_pc(D_pc), 
    .Branch(D_Branch), 
    .brjump(brjump), 
    .imm(D_imm), 
    .imm26(D_imm26), 
    .RD1(D_RS), 
    .npc(npc)
    );
	 
	 // D转发
	 assign D_RS =  (D_rs_addr == 0) ? 0 :
                   (D_rs_addr == E_A3dst) ? E_WD :
                   (D_rs_addr == M_A3dst) ? M_WD :
                                            D_rs;

    assign D_RT =  (D_rt_addr == 0) ? 0 :
                   (D_rt_addr == E_A3dst) ? E_WD :
                   (D_rt_addr == M_A3dst) ? M_WD :
                                            D_rt;
	 
	 // stageE
	 wire [31:0] E_pc, E_EXTout, E_rs, E_rt;
	 E_REG E_reg (
    .clk(clk), 
    .reset(reset || E_reg_reset), 
    .WE(E_reg_en), 
    .instr_in(D_instr), 
    .pc_in(D_pc), 
    .rs_in(D_RS), 
    .rt_in(D_RT), 
    .EXT_in(D_EXTout), 
    .instr_out(E_instr), 
    .pc_out(E_pc), 
    .rs_out(E_rs), 
    .rt_out(E_rt), 
    .EXT_out(E_EXTout)
    );
	 
	 wire [4:0] E_rs_addr, E_rt_addr;
	 wire [3:0] E_ALUcon;
	 wire E_ALUsel;
	 _CU E_cu (
    .instr(E_instr), 
    .rs_addr(E_rs_addr), 
    .rt_addr(E_rt_addr), 
    .ALUcon(E_ALUcon), 
    .ALUsel(E_ALUsel), 
    .WDsel(E_WDsel),  
    .A3dst(E_A3dst)
    );
	 
	 wire [31:0] E_in1, E_in2, E_ALUout, E_RS, E_RT;
	 E_ALU E_alu (
    .in1(E_in1), 
    .in2(E_in2), 
    .ALUcon(E_ALUcon), 
    .ALUout(E_ALUout)
    );
	 
	 // E转发
	 assign E_RS =  (E_rs_addr == 0) ? 0 :
                   (E_rs_addr == M_A3dst) ? M_WD :
                   (E_rs_addr == W_A3dst) ? W_WD :
                                            E_rs;

    assign E_RT =  (E_rt_addr == 0) ? 0 :
                   (E_rt_addr == M_A3dst) ? M_WD :
                   (E_rt_addr == W_A3dst) ? W_WD :
                                            E_rt;

    assign E_in1 = E_RS;

    assign E_in2 = (E_ALUsel) ? E_EXTout:
	                           E_RT;
    
	 
	 // stageM
	 wire [31:0] M_pc, M_ALUout, M_rt, M_EXTout;
	 M_REG M_reg (
    .clk(clk), 
    .reset(reset), 
    .WE(M_reg_en), 
    .instr_in(E_instr), 
    .pc_in(E_pc), 
    .ALU_in(E_ALUout), 
    .rt_in(E_RT), 
    .EXT_in(E_EXTout), 
    .instr_out(M_instr), 
    .pc_out(M_pc), 
    .ALU_out(M_ALUout), 
    .rt_out(M_rt), 
    .EXT_out(M_EXTout)
    );
	 
	 wire [4:0] M_rt_addr;
    wire [2:0] M_DMtype;
    wire MEMwrite;
    _CU M_cu (
    .instr(M_instr),
    .rt_addr(M_rt_addr),
    .MEMwrite(MEMwrite), 
    .DMtype(M_DMtype), 
    .WDsel(M_WDsel), 
    .A3dst(M_A3dst)
    );
	 
	 wire [31:0] M_DMout, M_RT;
	 M_DM M_dm (
    .pc(M_pc), 
    .clk(clk), 
    .reset(reset), 
    .DMaddr(M_ALUout), 
    .DMdata(M_RT), 
    .WE(MEMwrite), 
    .DMtype(M_DMtype), 
    .DMout(M_DMout)
    );
	 
	 // M转发
	 assign M_RT = (M_rt_addr == 0) ? 0 :
                  (M_rt_addr == W_A3dst) ? W_WD :
                                           M_rt;
												

    // stageW
	 wire [31:0] W_ALUout, W_DMout;
    W_REG W_reg(
    .clk(clk), 
    .reset(reset), 
    .WE(W_reg_en), 
    .instr_in(M_instr), 
    .pc_in(M_pc), 
    .ALU_in(M_ALUout), 
    .DM_in(M_DMout), 
    .instr_out(W_instr), 
    .pc_out(W_pc), 
    .ALU_out(W_ALUout), 
    .DM_out(W_DMout)
    ); 
	 
	  _CU W_cu(
     .instr(W_instr),
     .GRFwrite(W_GRFwrite), 
    .WDsel(W_WDsel), 
    .A3dst(W_A3dst)
    );

endmodule
