`timescale 1ns / 1ps
`include "const.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:44:49 12/14/2021 
// Design Name: 
// Module Name:    M_DP 
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
module M_DP(
    input [31:0] DMout_tmp,
    input [2:0] dp_sel,
    input [31:0] dp_addr,
    output [31:0] DMout
    );
	 
	 wire [31:0] word;
	 wire [15:0] hf;
	 wire [7:0] bt;
	 wire sign_hf, sign_bt;
	 
	 assign word = DMout_tmp;
	 assign hf = word[15 + dp_addr[1]*16-: 16];
    assign bt = word[7 + dp_addr[1:0]*8-: 8];
    assign sign_hf = word[15 + dp_addr[1]*16];
    assign sign_bt = word[7 + dp_addr[1:0]*8];
 
    assign DMout = (dp_sel == `dp_lw)? word :
					     (dp_sel == `dp_lh)? {{16{sign_hf}}, hf} :
					     (dp_sel == `dp_lb)? {{24{sign_bt}}, bt} :
					     (dp_sel == `dp_lhu)? {{16{1'b0}}, hf} :
					     (dp_sel == `dp_lbu)? {{24{1'b0}}, bt} :
					     word;
					  
    


endmodule
