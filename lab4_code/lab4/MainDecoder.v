`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/11 21:08:22
// Design Name: 
// Module Name: MainDecoder
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


module MainDecoder(
    input [5:0] opcode,     // inst[31:26]
    output RegWrite, MemWrite, MemRead,RegDst, ALUsrc, Mem2Reg, Beq, Jump,
    output [1:0] aluop
    );
    
    wire [0:9] control;
    assign RegDst = control[0];
    assign ALUsrc = control[1];
    assign Mem2Reg = control[2];
    assign Beq = control[3];
    assign MemWrite = control[4];
    assign MemRead = control[5];
    assign RegWrite = control[6];    
    assign Jump = control[7];
    assign aluop = control[8:9];
    
    // combinational logic
    assign control = 
    // R type instruction
    (opcode == 6'b00_0000) ? 10'b1000_0010_10 : // R type
    (opcode == 6'b00_1000) ? 10'b0100_0010_00 : // addi
    (opcode == 6'b10_1011) ? 10'b0100_1000_00 : // sw
    (opcode == 6'b10_0011) ? 10'b0110_0110_00 : // lw
    (opcode == 6'b00_0100) ? 10'b0001_0000_01 : // beq
    (opcode == 6'b00_0010) ? 10'b0000_0001_00 : // jump
    0;                                          // default
    
endmodule
