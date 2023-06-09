`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:04:34 11/16/2021
// Design Name:   mips
// Module Name:   D:/ise/p4_cpu/p4cpu_test.v
// Project Name:  p4_cpu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mips
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module p5cpu_test;

	// Inputs
	reg clk;
	reg reset;

	// Instantiate the Unit Under Test (UUT)
	mips uut (
		.clk(clk), 
		.reset(reset)
	);
	
	
	integer i;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
       	 
		// Add stimulus here
		for(i=0;i < 100;i = i + 1) begin
      clk = 1;
      #100;
      clk = 0;
      #100;
      end

      reset = 1;
      #100;




	end
      
endmodule

