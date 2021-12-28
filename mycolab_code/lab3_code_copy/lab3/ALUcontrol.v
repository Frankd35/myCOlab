`timescale 1ns / 1ps
`include "defines.vh"

module ALUcontrol(
    input [5:0] opcode,
    input [5:0] funct,  // inst[5:0]
    output [7:0] alucontrol
    );
    
    assign alucontrol = 
        // logic
        ((`EXE_AND == opcode) && (`AND == funct)) ? `EXE_AND_OP :
        ((`EXE_OR == opcode) && (`OR == funct)) ? `EXE_OR_OP :
        ((`EXE_XOR == opcode) && (`XOR == funct)) ? `EXE_XOR_OP :
        ((`EXE_NOR == opcode) && (`NOR == funct)) ? `EXE_NOR_OP :
        ((`EXE_ANDI == opcode) && (`ANDI == funct)) ? `EXE_ANDI_OP :
        ((`EXE_ORI == opcode) && (`ORI == funct)) ? `EXE_ORI_OP :
        ((`EXE_XORI == opcode) && (`XORI == funct)) ? `EXE_XORI_OP :
        ((`EXE_LUI == opcode) && (`LUI == funct)) ? `EXE_LUI_OP :
        
        // shift
        ((`EXE_SLL == opcode) && (`SLL == funct)) ? `EXE_SLL_OP :
        ((`EXE_SLLV == opcode) && (`SLLV == funct)) ? `EXE_SLLV_OP :
        ((`EXE_SRL == opcode) && (`SRL == funct)) ? `EXE_SRL_OP :
        ((`EXE_SRLV == opcode) && (`SRLV == funct)) ? `EXE_SRLV_OP :
        ((`EXE_SRA == opcode) && (`SRA == funct)) ? `EXE_SRA_OP :
        ((`EXE_SRAV == opcode) && (`SRAV == funct)) ? `EXE_SRAV_OP :
        
        // move
        // unused
        ((`EXE_MFHI == opcode) && (`MFHI == funct)) ? `EXE_MFHI_OP :
        ((`EXE_MTHI == opcode) && (`MTHI == funct)) ? `EXE_MTHI_OP :
        ((`EXE_MFLO == opcode) && (`MFLO == funct)) ? `EXE_MFLO_OP :
        ((`EXE_MTLO == opcode) && (`MTLO == funct)) ? `EXE_MTLO_OP :
        
        // arithmetic
        ((`EXE_SLT == opcode) && (`SLT == funct)) ? `EXE_SLT_OP :
        ((`EXE_SLTU == opcode) && (`SLTU == funct)) ? `EXE_SLTU_OP :
        ((`EXE_SLTI == opcode) && (`SLTI == funct)) ? `EXE_SLTI_OP :
        ((`EXE_SLTIU == opcode) && (`SLTIU == funct)) ? `EXE_SLTIU_OP :
        ((`EXE_ADD == opcode) && (`ADD == funct)) ? `EXE_ADD_OP :
        ((`EXE_ADDU == opcode) && (`ADDU == funct)) ? `EXE_ADDU_OP :
        ((`EXE_SUB == opcode) && (`SUB == funct)) ? `EXE_SUB_OP :
        ((`EXE_SUBU == opcode) && (`SUBU == funct)) ? `EXE_SUBU_OP :
        ((`EXE_ADDI == opcode) && (`ADDI == funct)) ? `EXE_ADDI_OP :
        ((`EXE_ADDIU == opcode) && (`ADDIU == funct)) ? `EXE_ADDIU_OP :
        
        ((`EXE_MULT == opcode) && (`MULT == funct)) ? `EXE_MULT_OP :
        ((`EXE_MULTU == opcode) && (`MULTU == funct)) ? `EXE_MULTU_OP :
        ((`EXE_DIV == opcode) && (`DIV == funct)) ? `EXE_DIV_OP :
        ((`EXE_DIVU == opcode) && (`DIVU == funct)) ? `EXE_DIVU_OP :
        
        // j-type
        ((`EXE_J == opcode) && (`J == funct)) ? `EXE_J_OP :
        ((`EXE_JAL == opcode) && (`JAL == funct)) ? `EXE_JAL_OP :
        ((`EXE_JALR == opcode) && (`JALR == funct)) ? `EXE_JALR_OP :
        ((`EXE_JR == opcode) && (`JR == funct)) ? `EXE_JR_OP :
        ((`EXE_BEQ == opcode) && (`BEQ == funct)) ? `EXE_BEQ_OP :
        ((`EXE_BGEZ == opcode) && (`BGEZ == funct)) ? `EXE_BGEZ_OP :
        ((`EXE_BGEZAL == opcode) && (`BGEZAL == funct)) ? `EXE_BGEZAL_OP :
        ((`EXE_BGTZ == opcode) && (`BGTZ == funct)) ? `EXE_BGTZ_OP :
        ((`EXE_BLEZ == opcode) && (`BLEZ == funct)) ? `EXE_BLEZ_OP :
        ((`EXE_BLTZ == opcode) && (`BLTZ == funct)) ? `EXE_BLTZ_OP :
        ((`EXE_BLTZAL == opcode) && (`BLTZAL == funct)) ? `EXE_BLTZAL_OP :
        ((`EXE_BNE == opcode) && (`BNE == funct)) ? `EXE_BNE_OP :
        
        // load & store
        ((`EXE_LB == opcode) && (`LB == funct)) ? `EXE_LB_OP :
        ((`EXE_LBU == opcode) && (`LBU == funct)) ? `EXE_LBU_OP :
        ((`EXE_LH == opcode) && (`LH == funct)) ? `EXE_LH_OP :
        ((`EXE_LHU == opcode) && (`LHU == funct)) ? `EXE_LHU_OP :
        ((`EXE_LW == opcode) && (`LW == funct)) ? `EXE_LW_OP :
        ((`EXE_SB == opcode) && (`SB == funct)) ? `EXE_SB_OP :
        ((`EXE_SH == opcode) && (`SH == funct)) ? `EXE_SH_OP :
        ((`EXE_SW == opcode) && (`SW == funct)) ? `EXE_SW_OP :
        8'hff;                          // default
endmodule