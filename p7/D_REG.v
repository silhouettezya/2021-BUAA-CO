`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:28:45 11/28/2021 
// Design Name: 
// Module Name:    D_REG 
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
module D_REG(
    input clk,
    input reset,
    input WE,
    input [31:0] instr_in,
    input [31:0] pc_in,
    output reg [31:0] instr_out,
    output reg [31:0] pc_out,
	 //exception
	 input req,
	 input [4:0] EXcode_in,
	 input delay_in,
	 output reg [4:0] EXcode_out,
	 output reg delay_out
    );
	 
	 initial begin
	 instr_out <= 0;
	 pc_out <= 0;
	 EXcode_out <= 0;
	 delay_out <= 0;
	 end
	 
	 always@(posedge clk) begin
	 if(reset || req) begin
	 instr_out <= 0;
	 pc_out <= req ? 32'h0000_4180 : 0;
	 EXcode_out <= 0;
	 delay_out <= 0;
	 end
	 else if(WE) begin
	 instr_out <= instr_in;
	 pc_out <= pc_in;
	 EXcode_out <= EXcode_in;
	 delay_out <= delay_in;
	 end
	 end
	 


endmodule
