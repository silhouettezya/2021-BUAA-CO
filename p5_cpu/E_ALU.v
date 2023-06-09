`timescale 1ns / 1ps
`include "const.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:43:40 11/15/2021 
// Design Name: 
// Module Name:    ALU 
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
module E_ALU(
    input [31:0] in1,
    input [31:0] in2,
    input [3:0] ALUcon,
    output [31:0] ALUout
    );
	 
	 assign ALUout = (ALUcon == `ALU_add) ? (in1 + in2):
	                 (ALUcon == `ALU_sub) ? (in1 - in2):
						  (ALUcon == `ALU_or) ? (in1 | in2):
						  (ALUcon == `ALU_slt) ? (in1 < in2):
						  (ALUcon == `ALU_lui) ? (in2 << 16):
						  32'b0;
						  


endmodule
