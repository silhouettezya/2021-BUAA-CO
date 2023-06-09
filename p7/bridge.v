`timescale 1ns / 1ps
`include "const.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:31:57 12/28/2021 
// Design Name: 
// Module Name:    BRIDGE 
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
module BRIDGE(
    input [31:0] pr_a,
    input pr_we,
    input interrupt,
    input irq1,
    input irq2,
    input [31:0] t1_out,
    input [31:0] t2_out,
    output t1_we,
    output t2_we,
    output [31:0] pr_rd,
    output [5:0] HWint
    );
	 
	 
	 wire [31:0] r_addr;
	 wire sel_t1, sel_t2;
	 
	 assign r_addr = {pr_a[31:2], 2'b0};
    assign sel_t1 = (r_addr >= `start_t1) && (r_addr <= `end_t1);
    assign sel_t2 = (r_addr >= `start_t2) && (r_addr <= `end_t2);

    assign t1_we = sel_t1 && pr_we;

    assign t2_we = sel_t2 && pr_we;

    assign pr_rd = (sel_t1) ? t1_out :
                   (sel_t2) ? t2_out :
                   0;

    assign HWint = {3'b0, interrupt, irq2, irq1};



endmodule
