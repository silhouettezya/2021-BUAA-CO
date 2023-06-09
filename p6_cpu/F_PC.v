`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:53:55 12/14/2021 
// Design Name: 
// Module Name:    F_PC 
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
module F_PC(
    input clk,
    input reset,
    input WE,
    input [31:0] npc,
    output reg [31:0] pc
    );
	 
	 initial begin
	 pc <= 32'h0000_3000;
	 end
	 
	 always @(posedge clk) begin
	 if(reset) begin
	 pc <= 32'h0000_3000;
	 end
	 else if(WE) begin
	 pc <= npc;
	 end
	 end
	 


endmodule
