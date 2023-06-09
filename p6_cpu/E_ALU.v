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
	 
	 wire [31:0] res_sra, res_slt;
	 assign res_sra = $signed($signed(in1) >>> in2);
	 assign res_slt = ($signed(in1) < $signed(in2)) ? 32'b1 : 32'b0;
	 
	 assign ALUout = (ALUcon == `ALU_add) ? (in1 + in2):
	                 (ALUcon == `ALU_sub) ? (in1 - in2):
						  (ALUcon == `ALU_or) ? (in1 | in2):
						  (ALUcon == `ALU_slt) ? res_slt:
						  (ALUcon == `ALU_sltu) ? (in1 < in2):
						  (ALUcon == `ALU_lui) ? (in2 << 16):
						  (ALUcon == `ALU_sll) ? (in1 << in2):
						  (ALUcon == `ALU_srl) ? (in1 >> in2):
						  (ALUcon == `ALU_sra) ? res_sra:
						  (ALUcon == `ALU_and) ? (in1 & in2):
						  (ALUcon == `ALU_xor) ? (in1 ^ in2):
						  (ALUcon == `ALU_nor) ? ~(in1 | in2):
						  32'b0;
						  


endmodule
