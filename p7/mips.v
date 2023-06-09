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
    input clk,                       // ʱ���ź�
    input reset,                     // ͬ����λ�ź�
    input interrupt,                 // �ⲿ�ж��ź�
    output [31:0] macroscopic_pc,    // ��� PC�������ģ�

    output [31:0] i_inst_addr,       // ȡָ PC
    input  [31:0] i_inst_rdata,      // i_inst_addr ��Ӧ�� 32 λָ��

    output [31:0] m_data_addr,       // ���ݴ洢����д���ַ
    input  [31:0] m_data_rdata,      // m_data_addr ��Ӧ�� 32 λ����
    output [31:0] m_data_wdata,      // ���ݴ洢����д������
    output [3 :0] m_data_byteen,     // �ֽ�ʹ���ź�

    output [31:0] m_inst_addr,       // M ��PC

    output w_grf_we,                 // grf дʹ���ź�
    output [4 :0] w_grf_addr,        // grf ��д��Ĵ������
    output [31:0] w_grf_wdata,       // grf ��д������

    output [31:0] w_inst_addr        // W �� PC
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
