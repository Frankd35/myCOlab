`timescale 1ns / 1ps
`include "defines.vh"
`include "defines2.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/22 13:17:14
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(
    input [31:0] in0,
    input [31:0] in1,
    input [4:0] shamt,
    input [7:0] alucontrol,
    output [31:0] out,
    output zero,overflow
    );
    wire [32:0] extra;


    // fucking shift, don't how it breaks
    // but this can work
    wire[31:0] asr_result,sl_result,sr_result;
    assign sl_result = in1 << shamt;
    assign sr_result = in1 >> shamt;
    assign asr_result = $signed(in1) >>> shamt;

    // combinational logic
    assign out = 
        (alucontrol == `EXE_AND_OP) ? in0 & in1 :     
        (alucontrol == `EXE_OR_OP) ? in0 | in1 :      
        (alucontrol == `EXE_XOR_OP) ? in0 ^ in1 :     
        (alucontrol == `EXE_NOR_OP) ? ~(in0 | in1) :  
        (alucontrol == `EXE_ANDI_OP) ? in0 & {16'b0, in1[15:0]} :
        (alucontrol == `EXE_ORI_OP) ? in0 | {16'b0, in1[15:0]} :
        (alucontrol == `EXE_XORI_OP) ? in0 ^ {16'b0, in1[15:0]} :
        (alucontrol == `EXE_LUI_OP) ? {in1[15:0], in0[15:0]} :   // immediate == in1

        // in0: reg[rs] / shamt     in1: reg[rt]
        
        // (alucontrol == `EXE_SLL_OP) ? in1 << shamt :
        // (alucontrol == `EXE_SLLV_OP) ? in1 << shamt :
        
        (alucontrol == `EXE_SLL_OP) ? sl_result :
        (alucontrol == `EXE_SLLV_OP) ? sl_result :
        (alucontrol == `EXE_SRL_OP) ? in1 >> shamt :
        (alucontrol == `EXE_SRLV_OP) ? in1 >> shamt :
        (alucontrol == `EXE_SRA_OP) ? asr_result :     // bit mask
        (alucontrol == `EXE_SRAV_OP) ? asr_result :

        // usigned means no OVERFLOW exception
        (alucontrol == `EXE_SLT_OP) ? ($signed(in0) < $signed(in1)) :
        (alucontrol == `EXE_SLTU_OP) ? (in0 < in1) :
        (alucontrol == `EXE_SLTI_OP) ? ($signed(in0) < $signed(in1)) :
        (alucontrol == `EXE_SLTIU_OP) ? (in0 < in1) :
        (alucontrol == `EXE_ADD_OP) ? in0 + in1 :
        (alucontrol == `EXE_ADDU_OP) ? in0 + in1 :
        (alucontrol == `EXE_SUB_OP) ? in0 - in1 :
        (alucontrol == `EXE_SUBU_OP) ? in0 - in1 :
        (alucontrol == `EXE_ADDI_OP) ? in0 + in1 :
        (alucontrol == `EXE_ADDIU_OP) ? in0 + in1 :

        // do not need alu
        // (alucontrol == `EXE_J_OP) ? in0 + in1 :
        // (alucontrol == `EXE_JAL_OP) ? in0 + in1 :
        // (alucontrol == `EXE_JALR_OP) ? in0 + in1 :
        // (alucontrol == `EXE_JR_OP) ? in0 + in1 :
        
        (alucontrol == `EXE_BEQ_OP) ? (in0 == in1 ? 1 : 0) :
        (alucontrol == `EXE_BGEZ_OP) ? (($signed(in0) < 0) ? 0 : 1):
        (alucontrol == `EXE_BGEZAL_OP) ? (($signed(in0) < 0) ? 0 : 1) :
        (alucontrol == `EXE_BGTZ_OP) ? (($signed(in0) > 0) ? 1 : 0) :
        (alucontrol == `EXE_BLEZ_OP) ? (($signed(in0) > 0) ? 0 : 1) :
        (alucontrol == `EXE_BLTZ_OP) ? (($signed(in0) < 0) ? 1 : 0) :
        (alucontrol == `EXE_BLTZAL_OP) ? (($signed(in0) < 0) ? 1 : 0) :
        (alucontrol == `EXE_BNE_OP) ? (in0 == in1 ? 0 : 1) :

        // do nothing here
        (alucontrol == `EXE_LB_OP) ? in0 + in1 :
        (alucontrol == `EXE_LBU_OP) ? in0 + in1 :
        (alucontrol == `EXE_LH_OP) ? in0 + in1 :
        (alucontrol == `EXE_LHU_OP) ? in0 + in1 :
        (alucontrol == `EXE_LW_OP) ? in0 + in1 :
        (alucontrol == `EXE_SB_OP) ? in0 + in1 :
        (alucontrol == `EXE_SH_OP) ? in0 + in1 :
        (alucontrol == `EXE_SW_OP) ? in0 + in1 :

        // (alucontrol == `EXE_SYNC_OP) ? in0 + in1 :
        32'hffff_fff0;                           // default
        
    assign zero = (out == 0) ? 1 : 0;

    // double signed bit
    assign extra = 
    ((alucontrol == `EXE_ADD_OP) | (alucontrol == `EXE_ADDI_OP)) ? {in0[31],in0} + {in1[31],in1} : 
    (alucontrol == `EXE_SUB_OP)? {in0[31],in0} - {in1[31],in1} :
    0;
    
    assign overflow = extra[31] ^ extra[32];
    

endmodule
