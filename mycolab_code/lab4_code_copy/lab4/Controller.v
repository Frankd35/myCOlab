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
    output PCsrc, RegWrite, MemWrite, MemRead,RegDst, ALUsrc, Mem2Reg, Beq, Jump, ShiftI, JumpV, Link
    );
    
    wire [5:0] opcode, funct;
    wire [4:0] rs,rt,rd;
    assign opcode = inst[31:26];
    assign funct = inst[5:0];
    assign rt = inst[20:16];

    assign PCsrc = zero & Beq;  // not used


    // using shamt field for shift, ALUin0 takes shamt not R[rs]
    assign ShiftI = (opcode == 6'b00_0000) & ((funct == `SLL) | (funct == `SRL) | (funct == `SRA));
    MainDecoder main_decoder(opcode,funct,RegWrite,MemWrite,MemRead,RegDst,ALUsrc,Mem2Reg,Beq,Jump,JumpV,Link);
    ALUcontrol alu_control(opcode,funct,rt,alucontrol);
    
endmodule
