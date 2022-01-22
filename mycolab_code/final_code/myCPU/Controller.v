`timescale 1ns / 1ps
`include "defines.vh"
`include "defines2.vh"

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/22 20:36:56
// Design Name: 
// Module Name: Controller
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


module Controller(
    input [31:0] inst,
    input zero,
    output [7:0] alucontrol,
    output PCsrc, RegWrite, MemWrite, MemRead,RegDst, ALUsrc, Mem2Reg, Beq, Jump, ShiftI, JumpV, Link,
    output SYSC_EXP,BREAK_EXP,RI_EXP,MFCP0,MTCP0
    );
    
    wire [5:0] opcode, funct;
    wire [4:0] rs,rt,rd;
    assign opcode = inst[31:26];
    assign funct = inst[5:0];
    assign rs = inst[25:21];
    assign rt = inst[20:16];

    assign PCsrc = zero & Beq;  // not used

    assign SYSC_EXP = (opcode == 6'b00_0000) & (funct == 5'b001100);
    assign BREAK_EXP = (opcode == 6'b00_0000) & (funct == 5'b001101);
    assign MFCP0 = (opcode == 6'b01_0000 & rs == 5'b00000);
    assign MTCP0 = (opcode == 6'b01_0000 & rs == 5'b00100);

    // using shamt field for shift, ALUin0 takes shamt not R[rs]
    assign ShiftI = (opcode == 6'b00_0000) & ((funct == `SLL) | (funct == `SRL) | (funct == `SRA));
    MainDecoder main_decoder(opcode,funct,rs,rt,RegWrite,MemWrite,MemRead,RegDst,ALUsrc,Mem2Reg,Beq,Jump,JumpV,Link,RI_EXP);
    ALUcontrol alu_control(opcode,funct,rt,alucontrol);
    
endmodule
