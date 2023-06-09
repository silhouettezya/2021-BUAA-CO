`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:17:37 11/16/2021
// Design Name:   IFU
// Module Name:   D:/ise/p4_cpu/IFU_test.v
// Project Name:  p4_cpu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: IFU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module IFU_test;

	// Inputs
	reg clk;
	reg reset;
	reg [31:0] npc;

	// Outputs
	wire [31:0] instr;
	wire [31:0] pc;
	wire [4:0] rs;
	wire [4:0] rt;
	wire [4:0] rd;
	wire [15:0] imm;
	wire [25:0] imm26;
	wire [5:0] OP;
	wire [5:0] Func;

	// Instantiate the Unit Under Test (UUT)
	IFU uut (
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
	integer i;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		npc = 0;

		// Wait 100 ns for global reset to finish
		#100;
				
        
		// Add stimulus here
      for(i=0;i < 30;i = i + 1) begin
		npc = pc + 4;
      clk = 1;
      #100;
      clk = 0;
      #100;
      end

      reset = 1;
      #100;

	end
      
endmodule

