
//opcode
`define OP_rtype 6'b000000
`define OP_beq 6'b000100
`define OP_jal 6'b000011
`define OP_lui 6'b001111
`define OP_lw 6'b100011
`define OP_ori 6'b001101
`define OP_sw 6'b101011

//func
`define FUNC_addu 6'b100001
`define FUNC_subu 6'b100011
`define FUNC_jr 6'b001000
`define FUNC_slt 6'b101010



//dmtype
`define dm_word 2'b00


//ALUcontrol
`define ALU_add 4'b0000
`define ALU_sub 4'b0001
`define ALU_or 4'b0010
`define ALU_slt 4'b0011
`define ALU_lui 4'b0100

//Branch
`define br_pc 3'b000
`define br_beq 3'b001
`define br_jal 3'b010
`define br_jr 3'b011

//Regsel
`define reg_rt 3'b000
`define reg_rd 3'b001
`define reg_31 3'b010

//WDsel
`define wd_mem 3'b000
`define wd_alu 3'b001
`define wd_pc4 3'b010



