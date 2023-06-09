`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:31:02 11/14/2021 
// Design Name: 
// Module Name:    GRF 
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
module D_GRF(
    input [31:0] W_pc,
    input clk,
    input reset,
    input WE,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD,
    output [31:0] RD1,
    output [31:0] RD2
    );
	 
	 reg [31:0] grf [31:0];
	 integer i;
	 
	 initial begin
	 for(i = 0;i < 32;i = i + 1) grf[i] <= 0;
	 end
	 
	 always@(posedge clk) begin
    if(reset == 1) begin
    for(i = 0;i <	32;i = i + 1) grf[i] <= 0;
	 end
	 
	 else if(WE == 1) begin
	 if(A3 != 0) grf[A3] <= WD;
	 end
	 
	 end
	 
	 assign RD1 = (A3 == A1 && A3 && WE) ? WD : grf[A1]; // 内部转发
    assign RD2 = (A3 == A2 && A3 && WE) ? WD : grf[A2];
	 


endmodule
