
//opcode
`define OP_rtype 6'b000000
`define OP_beq 6'b000100
`define OP_jal 6'b000011
`define OP_lui 6'b001111
`define OP_lw 6'b100011
`define OP_ori 6'b001101
`define OP_sw 6'b101011
`define OP_j 6'b000010
`define OP_lb 6'b100000
`define OP_lbu 6'b100100
`define OP_lh 6'b100001
`define OP_lhu 6'b100101
`define OP_andi 6'b001100
`define OP_addi 6'b001000
`define OP_addiu 6'b001001
`define OP_xori 6'b001110
`define OP_slti 6'b001010
`define OP_sltiu 6'b001011
`define OP_bne 6'b000101
`define OP_blez 6'b000110
`define OP_bgtz 6'b000111
`define OP_bltz 6'b000001
`define OP_bgez 6'b000001
`define OP_sh 6'b101001
`define OP_sb 6'b101000
`define OP_cp0 6'b010000
//cp0 code
`define cp0_mfc0 5'b00000
`define cp0_mtc0 5'b00100


//func
`define FUNC_addu 6'b100001
`define FUNC_subu 6'b100011
`define FUNC_add 6'b100000
`define FUNC_sub 6'b100010
`define FUNC_jr 6'b001000
`define FUNC_slt 6'b101010
`define FUCN_add 6'b100000
`define FUNC_sub 6'b100010
`define FUNC_sll 6'b000000
`define FUNC_srl 6'b000010
`define FUNC_sra 6'b000011
`define FUNC_sllv 6'b000100
`define FUNC_srlv 6'b000110
`define FUNC_srav 6'b000111
`define FUNC_and 6'b100100
`define FUNC_or 6'b100101
`define FUNC_xor 6'b100110
`define FUNC_nor 6'b100111
`define FUNC_sltu 6'b101011
`define FUNC_jalr 6'b001001
`define FUNC_mult 6'b011000
`define FUNC_multu 6'b011001
`define FUNC_div 6'b011010
`define FUNC_divu 6'b011011
`define FUNC_mfhi 6'b010000
`define FUNC_mflo 6'b010010
`define FUNC_mthi 6'b010001
`define FUNC_mtlo 6'b010011
`define FUNC_eret 6'b011000


//RTcode
`define RT_bltz 5'b00000
`define RT_bgez 5'b00001

//EXTop
`define ext_unsigned 3'b000
`define ext_signed 3'b001

//DMtype
`define dm_word 3'b000
`define dm_hword_unsigned 3'b001
`define dm_hword_signed 3'b010
`define dm_byte_unsigned 3'b011
`define dm_byte_signed 3'b100


//ALUcontrol
`define ALU_add 4'b0000
`define ALU_sub 4'b0001
`define ALU_or 4'b0010
`define ALU_slt 4'b0011
`define ALU_lui 4'b0100
`define ALU_sll 4'b0101
`define ALU_srl 4'b0110
`define ALU_sra 4'b0111
`define ALU_and 4'b1000
`define ALU_xor 4'b1001
`define ALU_nor 4'b1010
`define ALU_sltu 4'b1011

//Branch
`define br_pc 3'b000
`define br_beq 3'b001
`define br_jal 3'b010
`define br_jr 3'b011

//B_type
`define b_beq 3'b000
`define b_bne 3'b001
`define b_blez 3'b010
`define b_bgtz 3'b011
`define b_bltz 3'b100
`define b_bgez 3'b101 


//Regsel
`define reg_rt 3'b000
`define reg_rd 3'b001
`define reg_31 3'b010
`define reg_zero 3'b011

//WDsel
`define wd_mem 3'b000
`define wd_alu 3'b001
`define wd_pc4 3'b010
`define wd_hilo 3'b011
`define wd_cp0 3'b100

//ALUsel1
`define alu1_rs 2'b00
`define alu1_rt 2'b01

//ALUsel2
`define alu2_rt 3'b000
`define alu2_imm 3'b001
`define alu2_shamt 3'b010
`define alu2_rs5 3'b011

//HILOtype
`define HILO_mult 4'b0000
`define HILO_multu 4'b0001
`define HILO_div 4'b0010
`define HILO_divu 4'b0011
`define HILO_mflo 4'b0100
`define HILO_mfhi 4'b0101
`define HILO_mtlo 4'b0110
`define HILO_mthi 4'b0111
`define HILO_none 4'b1000

//be_sel
`define be_sw 3'b000
`define be_sh 3'b001
`define be_sb 3'b010
`define be_none 3'b011

//dp_sel
`define dp_lw 3'b000
`define dp_lh 3'b001
`define dp_lb 3'b010
`define dp_lhu 3'b011
`define dp_lbu 3'b100
`define dp_none 3'b101

//range of Maddr
`define start_dm 32'h0000_0000
`define end_dm 32'h0000_2fff
`define start_t1 32'h0000_7f00
`define end_t1 32'h0000_7f0b
`define start_t2 32'h0000_7f10
`define end_t2 32'h0000_7f1b

//excode
`define ex_int 5'd0
`define ex_adel 5'd4
`define ex_ades 5'd5
`define ex_ri 5'd10
`define ex_ov 5'd12
`define ex_none 5'd0

