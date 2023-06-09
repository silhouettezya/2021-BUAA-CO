`timescale 1ns / 1ps
`include "const.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:48:02 11/29/2021 
// Design Name: 
// Module Name:    D_CMP 
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
module D_CMP(
    input [31:0] in1,
    input [31:0] in2,
	 input [2:0] B_type,
    output brjump
    );
	 
	 wire les0 = in1[31];
	 wire eq0 = in1 == 0;
	 
	 assign brjump = ((B_type == `b_beq) && (in1 == in2))||
	                 ((B_type == `b_bne) && (in1 != in2))||
						  ((B_type == `b_blez) && (les0 || eq0))||
						  ((B_type == `b_bgtz) && (!les0 && !eq0))||
						  ((B_type == `b_bltz) && (les0))||
						  ((B_type == `b_bgez) && (!les0));


endmodule
