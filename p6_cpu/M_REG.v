`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:22:21 11/29/2021 
// Design Name: 
// Module Name:    M_REG 
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
module M_REG(
    input clk,
    input reset,
    input WE,
    input [31:0] instr_in,
    input [31:0] pc_in,
    input [31:0] ALU_in,
	 input [31:0] HILO_in,
    input [31:0] rt_in,
    input [31:0] EXT_in,
    output reg [31:0] instr_out,
    output reg [31:0] pc_out,
    output reg [31:0] ALU_out,
	 output reg [31:0] HILO_out,
    output reg [31:0] rt_out,
    output reg [31:0] EXT_out
    );
	 
	 initial begin
	 instr_out <= 0;
	 pc_out <= 0;
	 ALU_out <= 0;
	 HILO_out <= 0;
	 rt_out <= 0;
	 EXT_out <= 0;
	 end
	 
	 always@(posedge clk) begin
	 if(reset) begin
	 instr_out <= 0;
	 pc_out <= 0;
	 ALU_out <= 0;
	 HILO_out <= 0;
	 rt_out <= 0;
	 EXT_out <= 0;
	 end
	 else if(WE) begin
	 instr_out <= instr_in;
	 pc_out <= pc_in;
	 ALU_out <= ALU_in;
	 HILO_out <= HILO_in;
	 rt_out <= rt_in;
	 EXT_out <= EXT_in;
	 end
	 end

endmodule
