`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:23:11 11/30/2021 
// Design Name: 
// Module Name:    SU 
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
module SU(
    input [31:0] D_instr,
    input [31:0] E_instr,
    input [31:0] M_instr,
	 input E_HILObusy,
    output stall
    );
	 
	 // StageD
    wire D_calc_r, D_calc_i, D_load, D_store, D_j_r, D_j_br, D_shift_s, D_md, D_mt, D_mf, D_mtc0, D_eret;
    wire [4:0] D_rs_addr, D_rt_addr;
    _CU Dinter (
        .instr(D_instr),
        .rs_addr(D_rs_addr),
        .rt_addr(D_rt_addr),
        .calc_r(D_calc_r),
        .calc_i(D_calc_i),
		  .shift_s(D_shift_s),
		  .md(D_md),
		  .mt(D_mt),
		  .mf(D_mf),
        .load(D_load),
        .store(D_store),
        .j_r(D_j_r),
        .j_br(D_j_br),
		  .mtc0(D_mtc0),
		  .eret(D_eret)
    );

    wire [2:0] TuseRS, TuseRT;
	 assign TuseRS = (D_j_br || D_j_r) ? 0 :
                    ((D_calc_r && !D_shift_s) || D_calc_i || D_load || D_store || D_mt || D_md) ? 1 :
                                                                                                  3;
    assign TuseRT = D_j_br ? 0 :
                    (D_calc_r || D_md) ? 1 :
                    (D_store || D_mtc0) ? 2 :
                               3;
										 
    // StageE
    wire E_calc_r, E_calc_i, E_load, E_mf, E_mfc0, E_mtc0;
    wire [4:0] E_A3dst;
	 wire [4:0] E_rd;
    _CU Einter (
        .instr(E_instr),
		  .rd_addr(E_rd),
        .calc_r(E_calc_r),
        .calc_i(E_calc_i),
		  .mf(E_mf),
        .load(E_load),
		  .mfc0(E_mfc0),
		  .mtc0(E_mtc0),
        .A3dst(E_A3dst)
    );

    wire [2:0] TnewE;
	 assign TnewE =  (E_calc_r || E_calc_i || E_mf) ? 1 :
                        (E_load || E_mfc0) ? 2 :
                                 0; 
								
	// StageM
	wire M_load, M_mfc0, M_mtc0;
   wire [4:0] M_A3dst;
	wire [4:0] M_rd;
   _CU Minter (
        .instr(M_instr),
		  .rd_addr(M_rd),
        .load(M_load),
		  .mfc0(M_mfc0),
		  .mtc0(M_mtc0),
        .A3dst(M_A3dst)
    );

    wire [2:0] TnewM;
	 assign TnewM =  M_load ? 1 :
                             0;
								
	 // Tuse < Tnew
	 // stall_rs
    wire stall_rs_e, stall_rs_m, stall_rs;
	 assign stall_rs_e = (TuseRS < TnewE) && (D_rs_addr != 0) && (D_rs_addr == E_A3dst);
    assign stall_rs_m = (TuseRS < TnewM) && (D_rs_addr != 0) && (D_rs_addr == M_A3dst);
    assign stall_rs = stall_rs_e || stall_rs_m;
	 
	 // stall_rt
    wire stall_rt_e, stall_rt_m, stall_rt;
	 assign stall_rt_e = (TuseRT < TnewE) && (D_rt_addr != 0) && (D_rt_addr == E_A3dst);
    assign stall_rt_m = (TuseRT < TnewM) && (D_rt_addr != 0) && (D_rt_addr == M_A3dst);
    assign stall_rt = stall_rt_e || stall_rt_m;
    
	 //stall_hilo
	 wire stall_hilo;
    assign stall_hilo = E_HILObusy && (D_md | D_mt | D_mf);
	 
	 //stall_eret
	 //eret in D, mtc0(epc) in E or M
	 assign stall_eret = D_eret && ((E_mtc0 && (E_rd == 5'd14)) || (M_mtc0 && (M_rd == 5'd14)));

    assign stall = stall_rs || stall_rt || stall_hilo || stall_eret;


endmodule
