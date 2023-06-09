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
    output reg [31:0] pc_out
    );
	 
	 initial begin
	 instr_out <= 0;
	 pc_out <= 0;
	 end
	 
	 always@(posedge clk) begin
	 if(reset) begin
	 instr_out <= 0;
	 pc_out <= 0;
	 end
	 else if(WE) begin
	 instr_out <= instr_in;
	 pc_out <= pc_in;
	 end
	 end
	 


endmodule
