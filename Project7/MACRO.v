//ALU
`define ADD_  5'b00000//加
`define SUB_  5'b00001//减
`define OR_   5'b00010//或
`define AND_  5'b00011//与
`define XOR_  5'b00100
`define NOR_  5'b00101
`define SLT_  5'b00110
`define SLTU_ 5'b00111
`define LUI_  5'b01000
`define SLL_  5'b01001
`define SRL_  5'b01010
`define SRA_  5'b01011
//MDU
`define MULT_ 2'b00
`define MULTU_ 2'b01
`define DIV_ 2'b10
`define DIVU_ 2'b11
//NPC
`define INSTR_ADDR_WIDTH  32//
`define DATA_WIDTH        32//
`define PC4              3'b000//
`define IMM16            3'b001//
`define IMM26            3'b010//
`define REG              3'b011//
`define x4180             3'b100
`define EPC              3'b101
//IM
`define IM_REG_NUM 1024//寄存器最多存指令数目
`define INSTR_WIDTH 32//指令位宽
//DM
`define DM_REG_NUM 1024
`define DATA_ADDR_WIDTH 32
//GRF
`define REG_INDEX 5//寄存器编码
`define REG_NUM 32//GRF中寄存器数量
//控制器指令集
`define ADDU 12'b000000100001
`define SUBU 12'b000000100011
`define ADD  12'b000000100000
`define SUB  12'b000000100010
`define AND  12'b000000100100
`define OR   12'b000000100101
`define XOR  12'b000000100110
`define NOR  12'b000000100111
`define SLT  12'b000000101010
`define SLTU 12'b000000101011
`define SLLV 12'b000000000100
`define SRLV 12'b000000000110
`define SRAV 12'b000000000111

`define ADDIU 6'b001001
`define ADDI  6'b001000
`define ANDI  6'b001100
`define XORI  6'b001110
`define ORI   6'b001101
`define SLTI  6'b001010
`define SLTIU 6'b001011

`define LUI  6'b001111

`define BEQ  6'b000100
`define BNE  6'b000101
`define BLEZ 6'b000110
`define BGTZ 6'b000111
`define BLTZ 11'b00000100000//Opcode与rt位判断
`define BGEZ 11'b00000100001//Opcode与rt位判断

`define JAL  6'b000011
`define J    6'b000010
`define JR   12'b000000001000
`define JALR 12'b000000001001

`define SLL  12'b000000000000
`define SRL  12'b000000000010
`define SRA  12'b000000000011

`define MULT  12'b000000011000
`define MULTU 12'b000000011001
`define DIV   12'b000000011010
`define DIVU  12'b000000011011

`define MFHI  12'b000000010000
`define MFLO  12'b000000010010
`define MTHI  12'b000000010001
`define MTLO  12'b000000010011

`define LW  6'b100011
`define LB  6'b100000
`define LBU 6'b100100
`define LH  6'b100001
`define LHU 6'b100101

`define SW   6'b101011
`define SB   6'b101000
`define SH   6'b101001

`define ERET 12'b010000011000
`define MFC0 11'b01000000000//rs域
`define MTC0 11'b01000000100//rs域

//转发相关
`define M_RD2_EX 2
`define W_RD2_EX 1
`define M_RD1_EX 2
`define W_RD1_EX 1
`define W_DM_WrDM_M 1
`define E_IFU_Reg 3
`define M_IFU_Reg 2
`define W_IFU_Reg 1
`define E_COMP_COMP1 3									
`define M_COMP_COMP1 2									
`define W_COMP_COMP1 1									
`define E_COMP_COMP2 3									
`define M_COMP_COMP2 2									
`define W_COMP_COMP2 1									
