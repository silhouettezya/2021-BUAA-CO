`timescale 1ns / 1ps
`include "const.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:35:30 12/14/2021 
// Design Name: 
// Module Name:    M_BE 
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
module M_BE(
    input [31:0] Wdm_addr,
    input [31:0] Wdm_data_tmp,
    input [2:0] be_sel,
    output [3:0] byteen,
    output [31:0] Wdm_data
    );
	 
	 wire [3:0] wd, hf, bt;
	 reg [31:0] word = 32'b0 ;
	 
	 assign wd = 4'b1111;
    assign hf = (Wdm_addr[1] == 1'b1)? 4'b1100 : 
			            4'b0011;	  
    assign bt = (Wdm_addr[1:0] == 2'b00)? 4'b0001 :
			           (Wdm_addr[1:0] == 2'b01)? 4'b0010 :
			           (Wdm_addr[1:0] == 2'b10)? 4'b0100 :
			           4'b1000;
 
    assign byteen = (be_sel == `be_sw)? wd :
					     (be_sel == `be_sh)? hf :
					     (be_sel == `be_sb)? bt :
					     4'b0;
					  
    always@(*)begin
	    if(be_sel == `be_sw) word = Wdm_data_tmp;
	    else if(be_sel == `be_sh) word[15 + 16*Wdm_addr[1]-: 16] = Wdm_data_tmp[15:0];
	    else if(be_sel == `be_sb) word[7 + 8*Wdm_addr[1:0]-: 8] = Wdm_data_tmp[7:0];
    end
					  
    assign Wdm_data = word; 


endmodule
