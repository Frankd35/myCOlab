`timescale 1ns / 1ps
`include "defines.vh"
`include "defines2.vh"

module ALUcontrol(
    input [5:0] opcode,
    input [5:0] funct,
    input [4:0] rt,
    output [7:0] alucontrol
    );
    
    assign alucontrol = 
        // R-type
        (opcode == 6'b00_0000) ? (
        // -------------    trap instructions decode here!    ------------
        // unfinished

        // logic
        (`AND == funct) ? `EXE_AND_OP :
        (`OR == funct) ? `EXE_OR_OP :
        (`XOR == funct) ? `EXE_XOR_OP :
        (`NOR == funct) ? `EXE_NOR_OP :
        
        // shift
        (`SLL == funct) ? `EXE_SLL_OP :
        (`SLLV == funct) ? `EXE_SLLV_OP :
        (`SRL == funct) ? `EXE_SRL_OP :
        (`SRLV == funct) ? `EXE_SRLV_OP :
        (`SRA == funct) ? `EXE_SRA_OP :
        (`SRAV == funct) ? `EXE_SRAV_OP :
        
        // move
        (`MFHI == funct) ? `EXE_MFHI_OP :
        (`MTHI == funct) ? `EXE_MTHI_OP :
        (`MFLO == funct) ? `EXE_MFLO_OP :
        (`MTLO == funct) ? `EXE_MTLO_OP :
        
        // arithmetic
        (`SLT == funct) ? `EXE_SLT_OP :
        (`SLTU == funct) ? `EXE_SLTU_OP :
        (`ADD == funct) ? `EXE_ADD_OP :
        (`ADDU == funct) ? `EXE_ADDU_OP :
        (`SUB == funct) ? `EXE_SUB_OP :
        (`SUBU == funct) ? `EXE_SUBU_OP :
        
        // move
        (`MULT == funct) ? `EXE_MULT_OP :
        (`MULTU == funct) ? `EXE_MULTU_OP :
        (`DIV == funct) ? `EXE_DIV_OP :
        (`DIVU == funct) ? `EXE_DIVU_OP :
        
        // jump into register target
        (`JR == funct) ? `EXE_JR_OP :
        (`JALR == funct) ? `EXE_JALR_OP :
        0'hff       // default  
        ) :
        
        // logic immediate 
        (`ANDI == opcode) ? `EXE_ANDI_OP :
        (`ORI == opcode) ? `EXE_ORI_OP :  
        (`XORI == opcode) ? `EXE_XORI_OP :
        (`LUI == opcode) ? `EXE_LUI_OP :  

        // arithmetic immediate
        (`SLTI == opcode) ? `EXE_SLTI_OP :
        (`SLTIU == opcode) ? `EXE_SLTIU_OP :
        (`ADDI == opcode) ? `EXE_ADDI_OP :
        (`ADDIU == opcode) ? `EXE_ADDIU_OP :

        // J-type
        (`J == opcode) ? `EXE_J_OP :
        (`JAL == opcode) ? `EXE_JAL_OP :
        (`BEQ == opcode) ? `EXE_BEQ_OP :
        (`BGEZ == opcode) ? `EXE_BGEZ_OP :
        (`BGTZ == opcode) ? `EXE_BGTZ_OP :
        (`BLEZ == opcode) ? 
        (
            (rt == 5'b00000) ? `EXE_BLTZ_OP : 
            (rt == 5'b10000) ? `EXE_BLTZAL_OP : 
            (rt == 5'b00001) ? `EXE_BGEZ_OP : 
            (rt == 5'b10001) ? `EXE_BGEZAL_OP : 
            8'hff
        ) :
        // (`BLEZ == opcode) ? `EXE_BLEZ_OP :       these fucking inst has same opcode but  
        // (`BLTZ == opcode) ? `EXE_BLTZ_OP :       different rt field,
        // (`BGEZAL == opcode) ? `EXE_BGEZAL_OP :   figure it out before add em into datapath
        // (`BLTZAL == opcode) ? `EXE_BLTZAL_OP :
        (`BNE == opcode) ? `EXE_BNE_OP :
        
        // load & store
        (`LB == opcode) ? `EXE_LB_OP :
        (`LBU == opcode) ? `EXE_LBU_OP :
        (`LH == opcode) ? `EXE_LH_OP :
        (`LHU == opcode) ? `EXE_LHU_OP :
        (`LW == opcode) ? `EXE_LW_OP :
        (`SB == opcode) ? `EXE_SB_OP :
        (`SH == opcode) ? `EXE_SH_OP :
        (`SW == opcode) ? `EXE_SW_OP :        

        8'hff;                          // default
endmodule