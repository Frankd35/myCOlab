`timescale 1ns / 1ps
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
    input [5:0] opcode,
    input [5:0] funct,
    input zero,
    output [2:0] alucontrol,
    output PCsrc, RegWrite, MemWrite, MemRead,RegDst, ALUsrc, Mem2Reg, Beq, Jump
    );
    wire [1:0] aluop;
    
    assign PCsrc = zero & Beq;
    MainDecoder main_decoder(opcode,RegWrite,MemWrite,MemRead,RegDst,ALUsrc,Mem2Reg,Beq,Jump,aluop);
    ALUcontrol alu_control(aluop,funct,alucontrol);
    
endmodule
