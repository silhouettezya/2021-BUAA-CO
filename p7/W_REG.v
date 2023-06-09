`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:44:53 11/29/2021 
// Design Name: 
// Module Name:    W_REG 
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
module W_REG(
    input clk,
    input reset,
	 input WE,
    input [31:0] instr_in,
    input [31:0] pc_in,
    input [31:0] ALU_in,
	 input [31:0] HILO_in,
    input [31:0] DM_in,
	 output reg [31:0] instr_out,
	 output reg [31:0] pc_out,
    output reg [31:0] ALU_out,
	 output reg [31:0] HILO_out,
    output reg [31:0] DM_out,
	 //exception
	 input req,
	 input [31:0] cp0_in,
	 output reg [31:0] cp0_out
    );
	 
	 initial begin
	 instr_out <= 0;
	 pc_out <= 0;
	 ALU_out <= 0;
	 HILO_out <= 0;
	 DM_out <= 0;
	 cp0_out <= 0;
	 end
	 
	 always@(posedge clk) begin
	 if(reset | req) begin
	 instr_out <= 0;
	 pc_out <= req ? 32'h0000_4180 : 0;
	 ALU_out <= 0;
	 HILO_out <= 0;
	 DM_out <= 0;
	 cp0_out <= 0;
	 end
	 else if(WE) begin
	 instr_out <= instr_in;
	 pc_out <= pc_in;
	 ALU_out <= ALU_in;
	 HILO_out <= HILO_in;
	 DM_out <= DM_in;
	 cp0_out <= cp0_in;
	 end
	 end


endmodule
