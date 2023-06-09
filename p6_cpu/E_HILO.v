`timescale 1ns / 1ps
`include "const.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:51:52 12/14/2021 
// Design Name: 
// Module Name:    E_HILO 
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
module E_HILO(
    input clk,
    input reset,
    input [31:0] rs,
    input [31:0] rt,
    input [3:0] HILOtype,
    output HILObusy,
    output [31:0] HILOout
    );
	 
	 reg [31:0] hi, lo, hi_tmp, lo_tmp;
	 reg [4:0] state;
	 reg busy;
	 wire mult, multu, div, divu, mflo, mfhi, mtlo, mthi, start;
	 
	 assign mult = (HILOtype == `HILO_mult);
    assign multu = (HILOtype == `HILO_multu);
    assign div = (HILOtype == `HILO_div);
    assign divu = (HILOtype == `HILO_divu);
    assign mflo = (HILOtype == `HILO_mflo);
    assign mfhi = (HILOtype == `HILO_mfhi);
    assign mtlo = (HILOtype == `HILO_mtlo);
	 assign mthi = (HILOtype == `HILO_mthi);
	 
	 assign start = mult || multu || div || divu;
	 
	 assign HILObusy = start || busy;
	 
	 assign HILOout = mflo ? lo:
	                  mfhi ? hi:
							0;
							
	 initial begin
	 busy <= 0;
	 state <= 0;
	 hi <= 0;
	 lo <= 0;
	 hi_tmp <= 0;
	 lo_tmp <= 0;
	 end
	 
	 always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        busy <= 0;
        hi <= 0;
        lo <= 0;
		  hi_tmp <= 0;
	     lo_tmp <= 0;
    end 
	 else begin
        if (state == 0) begin
            if (mtlo) lo <= rs;
            else if (mthi) hi <= rs;
            else if (mult) begin
                busy <= 1;
                state <= 5;
                {hi_tmp, lo_tmp} <= $signed(rs) * $signed(rt);
            end 
				else if (multu) begin
                busy <= 1;
                state <= 5;
                {hi_tmp, lo_tmp} <= rs * rt;
            end 
				else if (div) begin
                busy <= 1;
                state <= 10;
                lo_tmp <= $signed(rs) / $signed(rt);
                hi_tmp <= $signed(rs) % $signed(rt);
            end 
				else if (divu) begin
                busy <= 1;
                state <= 10;
                lo_tmp <= rs / rt;
                hi_tmp <= rs % rt;
            end
        end 
		  else if (state == 1) begin
            state <= 0;
            busy <= 0;
            hi <= hi_tmp;
            lo <= lo_tmp;
        end 
		  else begin
            state <= state - 1;
        end
    end
    end


endmodule
