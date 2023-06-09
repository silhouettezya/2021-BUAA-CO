`timescale 1ns / 1ps
`include "const.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:02:30 11/14/2021 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
    input reset
    );
	 
	 wire beq, MEMwrite, ext, ALUsel, REGwrite;
	 
	 wire [31:0] npc, pc, instr, EXTout, ALUout, DMout, RD1, RD2;
	 
	 wire [15:0] imm;
	 
	 wire [25:0] imm26;
	 
	 wire [4:0] rs, rt, rd;
	 
	 wire [5:0] OP, Func;
	 
	 wire [3:0] ALUcon;
	 
	 wire [2:0] Branch, REGsel, WDsel;
	 
	 wire [1:0] Dmtype;
	 
	 IFU Ifu (
    .clk(clk), 
    .reset(reset), 
    .npc(npc), 
    .instr(instr), 
    .pc(pc), 
    .rs(rs), 
    .rt(rt), 
    .rd(rd), 
    .imm(imm), 
    .imm26(imm26), 
    .OP(OP), 
    .Func(Func)
    );
	 
	 Control_Unit CU (
    .OP(OP), 
    .Func(Func), 
    .WDsel(WDsel), 
    .MEMwrite(MEMwrite), 
    .ALUsel(ALUsel), 
    .REGwrite(REGwrite), 
    .ext(ext), 
    .Branch(Branch), 
    .REGsel(REGsel), 
    .ALUcon(ALUcon), 
    .Dmtype(Dmtype)
    );
	 
	 EXT Ext (
    .imm(imm), 
    .ext(ext), 
    .EXTout(EXTout)
    );
	 
	 GRF Grf (
	 .pc(pc),
    .clk(clk), 
    .reset(reset), 
    .we(REGwrite), 
    .A1(rs), 
    .A2(rt), 
    .A3((REGsel == `reg_rt) ? rt:
	     (REGsel == `reg_rd) ? rd:
		  (REGsel == `reg_31) ? 5'b11111:
		                        5'b0), 
    .WD((WDsel == `wd_mem) ? DMout:
	     (WDsel == `wd_alu) ? ALUout:
		  (WDsel == `wd_pc4) ? pc+4:
	                          0), 
    .RD1(RD1), 
    .RD2(RD2)
    );
	 
	 ALU Alu (
    .in1(RD1), 
    .in2((ALUsel) ? EXTout:
	                 RD2), 
    .ALUcon(ALUcon), 
    .ALUout(ALUout), 
    .Zero(beq)
    );
	 
	 DM Dm (
	 .pc(pc),
    .clk(clk), 
    .reset(reset), 
    .DMaddr(ALUout), 
    .DMdata(RD2), 
    .MEMwrite(MEMwrite), 
    .Dmtype(Dmtype), 
    .DMout(DMout)
    );
	 
	 NPC Npc (
    .pc(pc), 
    .Branch(Branch), 
    .beq(beq), 
    .RD1(RD1), 
    .imm(imm), 
    .imm26(imm26), 
    .npc(npc)
    );



	 


endmodule
