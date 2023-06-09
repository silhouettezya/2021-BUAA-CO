`timescale 1ns / 1ps
`include "const.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:05:19 11/15/2021 
// Design Name: 
// Module Name:    EXT 
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
module D_EXT(
    input [15:0] imm,
    input [2:0] EXTop,
    output [31:0] EXTout
    );
	 
	 assign EXTout = (EXTop == `ext_signed) ? {{16{imm[15]}},imm}: 
	                 (EXTop == `ext_unsigned) ? {16'b0,imm}:
						                             {16'b0,imm};


endmodule
