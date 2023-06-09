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
    input clk,                       // 时钟信号
    input reset,                     // 同步复位信号
    input interrupt,                 // 外部中断信号
    output [31:0] macroscopic_pc,    // 宏观 PC（见下文）

    output [31:0] i_inst_addr,       // 取指 PC
    input  [31:0] i_inst_rdata,      // i_inst_addr 对应的 32 位指令

    output [31:0] m_data_addr,       // 数据存储器待写入地址
    input  [31:0] m_data_rdata,      // m_data_addr 对应的 32 位数据
    output [31:0] m_data_wdata,      // 数据存储器待写入数据
    output [3 :0] m_data_byteen,     // 字节使能信号

    output [31:0] m_inst_addr,       // M 级PC

    output w_grf_we,                 // grf 写使能信号
    output [4 :0] w_grf_addr,        // grf 待写入寄存器编号
    output [31:0] w_grf_wdata,       // grf 待写入数据

    output [31:0] w_inst_addr        // W 级 PC
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
	               (E_WDsel == `wd_hilo) ? E_HILOout:
	               (E_WDsel == `wd_alu) ? E_ALUout:
		            (E_WDsel == `wd_pc4) ? E_pc + 8:
	                                      0;
	 assign M_WD = (M_WDsel == `wd_mem) ? M_DMout:
	               (M_WDsel == `wd_alu) ? M_ALUout:
						(M_WDsel == `wd_hilo) ? M_HILOout:
		            (M_WDsel == `wd_pc4) ? M_pc + 8:
	                                      0;
	 assign W_WD = (W_WDsel == `wd_mem) ? W_DMout:
	               (W_WDsel == `wd_alu) ? W_ALUout:
						(W_WDsel == `wd_hilo) ? W_HILOout:
		            (W_WDsel == `wd_pc4) ? W_pc + 8:
	                                      0;									  
    
	 // stageF
    wire [31:0] F_pc, npc;
	 assign F_instr =  i_inst_rdata;
	 assign i_inst_addr = F_pc;
	 
	 F_PC F_PC (
    .clk(clk), 
    .reset(reset), 
    .WE(F_pc_en), 
    .npc(npc), 
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
	 wire [2:0] D_B_type;
	 _CU D_cu (
    .instr(D_instr), 
    .rs_addr(D_rs_addr), 
    .rt_addr(D_rt_addr),  
    .imm(D_imm), 
    .imm26(D_imm26), 
    .Branch(D_Branch), 
	 .B_type(D_B_type),
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
    .npc(npc)
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
	 wire [2:0] E_ALUsel2;
	 wire [1:0] E_ALUsel1;
	 wire [3:0] E_HILOtype;
	 _CU E_cu (
    .instr(E_instr), 
    .rs_addr(E_rs_addr), 
    .rt_addr(E_rt_addr), 
    .ALUcon(E_ALUcon), 
	 .ALUsel1(E_ALUsel1),
    .ALUsel2(E_ALUsel2), 
	 .HILOtype(E_HILOtype),
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
	 
	 
	 wire [31:0] E_HILOout;
	 E_HILO E_hilo (
    .clk(clk), 
    .reset(reset), 
    .rs(E_RS), 
    .rt(E_RT), 
    .HILOtype(E_HILOtype), 
    .HILObusy(E_HILObusy), 
    .HILOout(E_HILOout)
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
    
	 
	 // stageM
	 wire [31:0] M_pc, M_ALUout, M_rt, M_EXTout, M_HILOout;
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
    .EXT_out(M_EXTout)
    );
	 
	 wire [4:0] M_rt_addr;
    wire [2:0] M_DMtype;
	 wire [2:0] M_BEsel, M_DPsel;
    wire MEMwrite;
    _CU M_cu (
    .instr(M_instr),
    .rt_addr(M_rt_addr),
    .BEsel(M_BEsel),
	 .DPsel(M_DPsel),
    .WDsel(M_WDsel), 
    .A3dst(M_A3dst)
    );
	 
	 
	 //DM
	 
	 wire [31:0] M_DMout, M_RT, Wdm_data, DMout_tmp;
	 wire [3:0] M_byteen;
	 M_BE m_be (
    .Wdm_addr(M_ALUout), 
    .Wdm_data_tmp(M_RT), 
    .be_sel(M_BEsel), 
    .byteen(M_byteen), 
    .Wdm_data(Wdm_data)
    );
	 
	 M_DP M_dp (
    .DMout_tmp(DMout_tmp), 
    .dp_sel(M_DPsel), 
    .dp_addr(M_ALUout), 
    .DMout(M_DMout)
    );
	 
	 assign m_data_addr = {M_ALUout[31:2], 2'b0}; // dwa
 
    assign m_data_byteen = M_byteen; //dwe and write where
 
    assign m_data_wdata = Wdm_data; //Wdm_data
 
    assign m_inst_addr = M_pc; //M_pc
 
    assign DMout_tmp = m_data_rdata;  // O
	 
	 // M转发
	 assign M_RT = (M_rt_addr == 0) ? 0 :
                  (M_rt_addr == W_A3dst) ? W_WD :
                                           M_rt;
												

    // stageW
	 wire [31:0] W_ALUout, W_DMout, W_HILOout;
    W_REG W_reg(
    .clk(clk), 
    .reset(reset), 
    .WE(W_reg_en), 
    .instr_in(M_instr), 
    .pc_in(M_pc), 
    .ALU_in(M_ALUout),
    .HILO_in(M_HILOout),	 
    .DM_in(M_DMout), 
    .instr_out(W_instr), 
    .pc_out(W_pc), 
    .ALU_out(W_ALUout), 
	 .HILO_out(W_HILOout),
    .DM_out(W_DMout)
    ); 
	 
	  _CU W_cu(
     .instr(W_instr),
     .GRFwrite(W_GRFwrite), 
    .WDsel(W_WDsel), 
    .A3dst(W_A3dst)
    );
	 
	 assign macroscopic_pc = M_pc;

endmodule
