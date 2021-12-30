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
    output RegWrite, MemWrite, MemRead,RegDst, ALUsrc, Mem2Reg, Beq, Jump
    );
    
    wire [0:7] control;
    assign RegDst = control[0];
    assign ALUsrc = control[1];
    assign Mem2Reg = control[2];
    assign Beq = control[3];
    assign MemWrite = control[4];
    assign MemRead = control[5];
    assign RegWrite = control[6];    
    assign Jump = control[7];
    
    // combinational logic
    assign control = 
    // R type instruction
    (opcode == 6'b00_0000) ? 8'b1000_0010 : // R-type
    (opcode[5:3] == 3'b001) ? 8'b0100_0010 : // I-tyoe
    (opcode == 6'b10_1011) ? 8'b0100_1000 : // sw
    (opcode == 6'b10_0011) ? 8'b0110_0110 : // lw
    (opcode == 6'b00_0100) ? 8'b0001_0000 : // beq
    (opcode == 6'b00_0010) ? 8'b0000_0001 : // jump
    0;                                          // default
    
endmodule
