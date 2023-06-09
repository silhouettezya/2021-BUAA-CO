`timescale 1ns / 1ps
`include "const.v"
`define im sr[15:10]
`define exl sr[1]
`define ie sr[0]
`define bd cause[31]
`define ip cause[15:10]
`define ex_code cause[6:2]
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:48:40 12/27/2021 
// Design Name: 
// Module Name:    M_CP0 
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
module M_CP0(
    input clk,
	 input reset,
    input [4:0] A1,
    input [4:0] A2,
    input [31:0] WD,
    input [31:0] pc,
    input [4:0] EXcode,
    input delay,
	 input WE,
	 input [5:0] HWint,
	 input EXLclr,
	 output req,
	 output [31:0] epc,
	 output [31:0] CP0out,
	 output int_en
    );
	 
	 reg [31:0] sr;
	 reg [31:0] cause;
	 reg [31:0] epc_reg;
	 reg [31:0] prid;
	 wire [31:0] epc_tmp;
	 
	 wire req_int, req_ex;
	 
	 assign int_en = ((|(HWint[2] & sr[12])) & !`exl & `ie);
	 
	 assign req_int = ((|(HWint & `im)) & !`exl & `ie);
	 assign req_ex = (|EXcode) & !`exl;
	 assign req = req_int || req_ex;
	 
	 assign epc_tmp = (req)? ((delay)? pc - 32'h4 : pc)
                        : epc_reg;
	 assign epc = epc_tmp;
	 
	 initial begin
	 sr = 0;
	 cause = 0;
	 epc_reg = 0;
	 prid = 32'h2001_1123;
	 end
	 
	 always @(posedge clk) begin
    if(reset)begin
    sr <= 0;
    cause <= 0;
    epc_reg <= 0;
    end
    else begin
        if(EXLclr)begin // eret in M
            `exl <= 1'b0;
        end
        if(req)begin // int | ex
            `ex_code <= req_int? 5'b0 : EXcode;
            `exl <= 1'b1;
            epc_reg <= epc_tmp;
            `bd <= delay;
        end
        else if(WE)begin // mtc0 & !(int | ex)
            if(A2 == 5'd12)begin
                sr <= WD;
            end
            else if(A2 == 5'd14)begin
                epc_reg <= WD;
            end
        end
        `ip <= HWint;
    end
    end
	 
	 assign CP0out = (A1 == 5'd12)? sr:
                    (A1 == 5'd13)? cause:
                    (A1 == 5'd14)? epc:
                    (A1 == 5'd15)? prid:
                    0;


endmodule
