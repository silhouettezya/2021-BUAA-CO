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
module CPU(
    input clk,
    input reset,
	 input [31:0] i_inst_rdata,
    input [31:0] m_data_rdata, 
    output [31:0] i_inst_addr, 
    output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
    output [3:0] m_data_byteen,
    output [31:0] m_inst_addr,
    output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr,
	 //exception
	 input [5:0] HWint,
    input [31:0] pr_rd,
    output pr_we,
    output [31:0] pr_a,
    output [31:0] pr_wd,
    output [31:0] M_pc_out
    );
	 // stallcontrol
	 wire stall, req;
	 wire F_pc_en, D_reg_en, E_reg_en, M_reg_en, W_reg_en; // Reg En
	 wire E_reg_reset;
	 
	 assign F_pc_en = !stall;
	 assign D_reg_en = !stall;
	 assign E_reg_en = 1;
	 assign M_reg_en = 1;
	 assign W_reg_en = 1;
	 
	 assign E_reg_reset = stall;
	 
	 wire [31:0] F_instr, D_instr, E_instr, M_instr, W_instr;
	 wire E_HILObusy;
	 SU su(
	 .D_instr(D_instr),
    .E_instr(E_instr),
    .M_instr(M_instr),
	 .E_HILObusy(E_HILObusy),
    .stall(stall)
    );
	 
	 // mux_WD
	 wire [31:0] E_WD, M_WD, W_WD;
	 wire [4:0] E_A3dst, M_A3dst, W_A3dst;
	 wire [2:0] E_WDsel, M_WDsel, W_WDsel;
	 assign E_WD = //(E_WDsel == `wd_mem) ? E_DMout:
	               //(E_WDsel == `wd_hilo) ? E_HILOout:
	               //(E_WDsel == `wd_alu) ? E_ALUout:
		            (E_WDsel == `wd_pc4) ? E_pc + 8:
	                                      0;
	 assign M_WD = //(M_WDsel == `wd_mem) ? M_DMout:
	               (M_WDsel == `wd_alu) ? M_ALUout:
						(M_WDsel == `wd_hilo) ? M_HILOout:
		            (M_WDsel == `wd_pc4) ? M_pc + 8:
	                                      0;
	 assign W_WD = (W_WDsel == `wd_mem) ? W_DMout:
	               (W_WDsel == `wd_alu) ? W_ALUout:
						(W_WDsel == `wd_hilo) ? W_HILOout:
		            (W_WDsel == `wd_pc4) ? W_pc + 8:
						(W_WDsel == `wd_cp0)? W_CP0out:
	                                      0;									  
    
	 // stageF
    wire [31:0] F_pc, npc, epc;
	 wire [4:0] F_EXcode;
	 wire F_EXadel, F_delay;
	 wire D_eret;
	 
	 assign F_instr =  (F_EXadel)? 32'd0 : i_inst_rdata;
	 assign i_inst_addr = F_pc;
	 
	 F_PC F_PC (
    .clk(clk), 
    .reset(reset), 
    .WE(F_pc_en), 
    .npc(npc), 
    .pc(F_pc),
	 .req(req), 
    .eret(D_eret), 
    .epc(epc), 
    .EXadel(F_EXadel)
    );
	 
	 //F_ex
	 assign F_EXcode = (F_EXadel) ? `ex_adel : `ex_none;
	 assign F_delay = (D_Branch != `br_pc);
	 
	 // stageD
	 wire [31:0] D_pc;
	 wire [4:0] D_excode, D_EXcode;
	 wire D_delay;
    D_REG D_reg (
    .clk(clk),
    .reset(reset),
    .WE(D_reg_en),
    .instr_in(F_instr),
    .pc_in(F_pc),
    .instr_out(D_instr),
    .pc_out(D_pc),
	 .req(req), 
    .EXcode_in(F_EXcode), 
    .delay_in(F_delay), 
    .EXcode_out(D_excode), 
    .delay_out(D_delay)
    );
	 
	 wire [4:0] D_rs_addr, D_rt_addr;
	 wire [15:0] D_imm;
	 wire [25:0] D_imm26;
	 wire [2:0] D_Branch;
	 wire [2:0] D_EXTop;
	 wire [2:0] D_B_type;
	 wire D_EXri;
	 
	 _CU D_cu (
    .instr(D_instr), 
    .rs_addr(D_rs_addr), 
    .rt_addr(D_rt_addr),  
    .imm(D_imm), 
    .imm26(D_imm26), 
    .Branch(D_Branch), 
	 .B_type(D_B_type),
    .EXTop(D_EXTop),
	 .EXri(D_EXri),
	 .eret(D_eret)
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
	 .B_type(D_B_type),
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
    .npc(npc),
	 .req(req),
    .eret(D_eret),
    .epc(epc)
    );
	 
	 //for test
    assign w_grf_we = W_GRFwrite;
 
    assign w_grf_addr = W_A3dst;
 
    assign w_grf_wdata = W_WD;
 
    assign w_inst_addr = W_pc;
	 
	 // D转发
	 assign D_RS =  (D_rs_addr == 0) ? 0 :
                   (D_rs_addr == E_A3dst) ? E_WD :
                   (D_rs_addr == M_A3dst) ? M_WD :
                                            D_rs;

    assign D_RT =  (D_rt_addr == 0) ? 0 :
                   (D_rt_addr == E_A3dst) ? E_WD :
                   (D_rt_addr == M_A3dst) ? M_WD :
                                            D_rt;
	 //D_ex
	 assign D_EXcode = (D_excode)? D_excode :
                      (D_EXri)? `ex_ri :
                      `ex_none;
	 
	 // stageE
	 wire [31:0] E_pc, E_EXTout, E_rs, E_rt;
	 wire [4:0] E_excode, E_EXcode;
	 wire E_delay;
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
    .EXT_out(E_EXTout),
	 .req(req), 
    .stall(stall), 
    .EXcode_in(D_EXcode), 
    .delay_in(D_delay), 
    .EXcode_out(E_excode), 
    .delay_out(E_delay)
    );
	 
	 wire [4:0] E_rs_addr, E_rt_addr;
	 wire [3:0] E_ALUcon;
	 wire [2:0] E_ALUsel2;
	 wire [1:0] E_ALUsel1;
	 wire [3:0] E_HILOtype;
	 wire E_ALUadsub, E_ALUdm, E_eret;
	 _CU E_cu (
    .instr(E_instr), 
    .rs_addr(E_rs_addr), 
    .rt_addr(E_rt_addr), 
    .ALUcon(E_ALUcon), 
	 .ALUsel1(E_ALUsel1),
    .ALUsel2(E_ALUsel2), 
	 .HILOtype(E_HILOtype),
    .WDsel(E_WDsel),  
    .A3dst(E_A3dst),
	 .ALUadsub(E_ALUadsub),
    .ALUdm(E_ALUdm),
    .eret(E_eret)
    );
	 
	 wire [31:0] E_in1, E_in2, E_ALUout, E_RS, E_RT;
	 wire E_EXadsub, E_EXdm;
	 E_ALU E_alu (
    .in1(E_in1), 
    .in2(E_in2), 
    .ALUcon(E_ALUcon), 
    .ALUout(E_ALUout),
	 .ALUadsub(E_ALUadsub),
    .ALUdm(E_ALUdm),
	 .EXadsub(E_EXadsub),
    .EXdm(E_EXdm)
    );
	 
	 
	 wire [31:0] E_HILOout;
	 E_HILO E_hilo (
    .clk(clk), 
    .reset(reset), 
    .rs(E_RS), 
    .rt(E_RT), 
    .HILOtype(E_HILOtype), 
    .HILObusy(E_HILObusy), 
    .HILOout(E_HILOout),
	 .req(req)
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

    assign E_in1 = (E_ALUsel1 == `alu1_rs) ? E_RS:
	                (E_ALUsel1 == `alu1_rt) ? E_RT:
						                           0;

    assign E_in2 = (E_ALUsel2 == `alu2_imm) ? E_EXTout:
	                (E_ALUsel2 == `alu2_rt) ? E_RT:
						 (E_ALUsel2 == `alu2_shamt) ? {27'b0,E_instr[10:6]}:
						 (E_ALUsel2 == `alu2_rs5) ? {27'b0,E_RS[4:0]}:
						                           0;
    
	 //E_ex
    assign E_EXcode = (E_excode)? E_excode :
                      (E_EXadsub)? `ex_ov :
                      `ex_none;
	 
	 // stageM
	 wire [31:0] M_pc, M_ALUout, M_rt, M_EXTout, M_HILOout;
	 wire [4:0] M_EXcode, M_excode;
	 wire M_delay, M_EXdm;
	 
	 M_REG M_reg (
    .clk(clk), 
    .reset(reset), 
    .WE(M_reg_en), 
    .instr_in(E_instr), 
    .pc_in(E_pc), 
    .ALU_in(E_ALUout),
    .HILO_in(E_HILOout),	 
    .rt_in(E_RT), 
    .EXT_in(E_EXTout), 
    .instr_out(M_instr), 
    .pc_out(M_pc), 
    .ALU_out(M_ALUout),
    .HILO_out(M_HILOout),	 
    .rt_out(M_rt), 
    .EXT_out(M_EXTout),
	 .req(req), 
    .EXcode_in(E_EXcode), 
    .delay_in(E_delay), 
    .EXdm_in(E_EXdm), 
    .EXcode_out(M_excode), 
    .delay_out(M_delay), 
    .EXdm_out(M_EXdm)
    );
	 
	 wire [4:0] M_rt_addr, M_rd_addr;
    wire [2:0] M_DMtype;
	 wire [2:0] M_BEsel, M_DPsel;
    wire MEMwrite, M_cwe, M_eret, M_load, M_store;
    _CU M_cu (
    .instr(M_instr),
    .rt_addr(M_rt_addr),
	 .rd_addr(M_rd_addr),
    .BEsel(M_BEsel),
	 .DPsel(M_DPsel),
    .WDsel(M_WDsel), 
    .A3dst(M_A3dst),
	 .cwe(M_cwe), 
    .eret(M_eret), 
    .load(M_load), 
    .store(M_store) 
    );
	 
	 
	 //DM
	 
	 wire [31:0] M_DMout, M_RT, Wdm_data, DMout_tmp;
	 wire [3:0] M_byteen;
	 wire M_EXades, M_EXadel;
	 M_BE m_be (
    .Wdm_addr(M_ALUout), 
    .Wdm_data_tmp(M_RT), 
    .be_sel(M_BEsel), 
    .byteen(M_byteen), 
    .Wdm_data(Wdm_data),
	 .EXdm(M_EXdm),
	 .store(M_store),
	 .EXades(M_EXades)
    );
	 
	 M_DP M_dp (
    .DMout_tmp(DMout_tmp), 
    .dp_sel(M_DPsel), 
    .dp_addr(M_ALUout), 
    .DMout(M_DMout),
	 .EXdm(M_EXdm),
	 .load(M_load),
	 .EXadel(M_EXadel)
    );
	 
	 wire [31:0] M_CP0out;
	 wire int_en;
	 
	 M_CP0 m_CP0 (
    .clk(clk), 
    .reset(reset), 
    .A1(M_rd_addr), 
    .A2(M_rd_addr), 
    .WD(M_RT), 
    .pc(M_pc), 
    .EXcode(M_EXcode), 
    .delay(M_delay), 
    .WE(M_cwe), 
    .HWint(HWint), 
    .EXLclr(M_eret), 
    .req(req), 
    .epc(epc), 
    .CP0out(M_CP0out), 
    .int_en(int_en)
    );

	 
	 assign m_data_addr = (int_en)? 32'h0000_7f20 : M_ALUout; // dwa
 
    assign m_data_byteen = (int_en)? 1'b1 : M_byteen; //dwe and write where
 
    assign m_data_wdata = Wdm_data; //Wdm_data
 
    assign m_inst_addr = M_pc; //M_pc
 
    assign DMout_tmp = m_data_rdata;  // O
	 
	 // M转发
	 assign M_RT = (M_rt_addr == 0) ? 0 :
                  (M_rt_addr == W_A3dst) ? W_WD :
                                           M_rt;
	 
	 assign M_pc_out = M_pc;

    assign pr_we = (|M_byteen) && (!req) && (M_ALUout >= 32'h0000_7f00);

    assign pr_a = M_ALUout;

    assign pr_wd = M_RT;
	 
	 //M_ex
	 assign M_EXcode =  (M_excode)? M_excode :
                        (M_EXadel)? `ex_adel :
                        (M_EXades)? `ex_ades :
                        `ex_none;
	 

    // stageW
	 wire [31:0] W_ALUout, W_DMout, W_HILOout, W_CP0out;
    W_REG W_reg(
    .clk(clk), 
    .reset(reset), 
    .WE(W_reg_en), 
    .instr_in(M_instr), 
    .pc_in(M_pc), 
    .ALU_in(M_ALUout),
    .HILO_in(M_HILOout),	 
    .DM_in((M_ALUout >= 32'h0000_7f00) ? pr_rd : M_DMout), 
    .instr_out(W_instr), 
    .pc_out(W_pc), 
    .ALU_out(W_ALUout), 
	 .HILO_out(W_HILOout),
    .DM_out(W_DMout),
	 .req(req), 
    .cp0_in(M_CP0out), 
    .cp0_out(W_CP0out)
    ); 
	 
	  _CU W_cu(
     .instr(W_instr),
     .GRFwrite(W_GRFwrite), 
    .WDsel(W_WDsel), 
    .A3dst(W_A3dst)
    );

endmodule
