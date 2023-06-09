`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:46:12 12/28/2021 
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
	 
	 
	 wire [31:0] pr_a, pr_wd, pr_rd, t1_out, t2_out;
	 wire [5:0] HWint;
	 wire pr_we, irq1, irq2, t1_we, t2_we;
	 
	 
	 CPU cpu (
    .clk(clk), 
    .reset(reset), 
    .i_inst_rdata(i_inst_rdata), 
    .m_data_rdata(m_data_rdata), 
    .i_inst_addr(i_inst_addr), 
    .m_data_addr(m_data_addr), 
    .m_data_wdata(m_data_wdata), 
    .m_data_byteen(m_data_byteen), 
    .m_inst_addr(m_inst_addr), 
    .w_grf_we(w_grf_we), 
    .w_grf_addr(w_grf_addr), 
    .w_grf_wdata(w_grf_wdata), 
    .w_inst_addr(w_inst_addr), 
    .HWint(HWint), 
    .pr_rd(pr_rd), 
    .pr_we(pr_we), 
    .pr_a(pr_a), 
    .pr_wd(pr_wd), 
    .M_pc_out(macroscopic_pc)
    );
	 
	 BRIDGE bridge (
    .pr_a(pr_a), 
    .pr_we(pr_we), 
    .interrupt(interrupt), 
    .irq1(irq1), 
    .irq2(irq2), 
    .t1_out(t1_out), 
    .t2_out(t2_out), 
    .t1_we(t1_we), 
    .t2_we(t2_we), 
    .pr_rd(pr_rd), 
    .HWint(HWint)
    );
	 
	 TC tc1(
	.clk(clk),
	.reset(reset),
	.Addr(pr_a[31:2]),
	.WE(t1_we),
	.Din(pr_wd),
	.Dout(t1_out),
	.IRQ(irq1)
	);

	TC tc2(
	.clk(clk),
	.reset(reset),
	.Addr(pr_a[31:2]),
	.WE(t2_we),
	.Din(pr_wd),
	.Dout(t2_out),
	.IRQ(irq2)
	);


endmodule
