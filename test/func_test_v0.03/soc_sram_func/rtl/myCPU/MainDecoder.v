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
    input [5:0] opcode, funct,
    input [4:0] rt,
    output RegWrite, MemWrite, MemRead,RegDst, ALUsrc, Mem2Reg, Beq, Jump, JumpV, Link
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
    (opcode == 6'b00_0000 & funct == 6'b00_1000) ? 8'b1000_0001 : // Jr
    (opcode == 6'b00_0000 & funct == 6'b00_1001) ? 8'b1000_0011 : // Jalr
    (opcode == 6'b00_0000 & funct[5:1] == 5'b01100) ? 8'b1000_0000 : // mult
    (opcode == 6'b00_0000 & funct[5:1] == 5'b01101) ? 8'b1000_0000 : // div
    (opcode == 6'b00_0000 & funct[5:2] == 4'b0100 & funct[0] == 1) ? 8'b1000_0000 : // mthi & mtlo
    (opcode == 6'b00_0000) ? 8'b1000_0010 : // R-type
    (opcode[5:3] == 3'b001) ? 8'b0100_0010 : // I-type
    (opcode[5:3] == 3'b101) ? 8'b0100_1000 : // store
    (opcode[5:3] == 3'b100) ? 8'b0110_1110 : // load
    ((opcode == 6'b000001) & rt[4]) ? 8'b1001_0010 : // branch and link
    ((opcode[5:2] == 4'b0001) | (opcode == 6'b000001)) ? 8'b1001_0000 : // branch
    (opcode == 5'b00_0010) ? 8'b1000_0001 : // j
    (opcode == 5'b00_0011) ? 8'b1000_0011 : // jal
    0;                                          // default
    
    // unused signal
    assign Link = (opcode == 6'b00_0000 & funct == 6'b00_1001) |    //jalr
                  (opcode == 6'b00_0011);                           // jal
    assign JumpV = (opcode == 6'b00_0000 & funct[5:1] == 5'b00100);   // jr & jalr


endmodule
