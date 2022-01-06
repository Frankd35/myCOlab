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
    input [4:0] rs,rt,
    output RegWrite, MemWrite, MemRead,RegDst, ALUsrc, Mem2Reg, Beq, Jump, JumpV, Link, RI_EXP
    );
    
    wire [0:8] control;
    assign RegDst = control[0];
    assign ALUsrc = control[1];
    assign Mem2Reg = control[2];
    assign Beq = control[3];
    assign MemWrite = control[4];
    assign MemRead = control[5];
    assign RegWrite = control[6];    
    assign Jump = control[7];
    assign RI_EXP = control[8];

    // combinational logic
    assign control = 
    (opcode == 6'b00_0000 & funct[5:1] == 5'b00110) ? 0 : // exception
    // fetch/to cp0 
    (opcode == 6'b01_0000 & rs == 5'b00100) ? 9'b1000_0000_0 : // mtcp0
    (opcode == 6'b01_0000 & rs == 5'b00000) ? 9'b1000_0010_0 : // mfcp0
    // R type instruction
    (opcode == 6'b00_0000 & funct == 6'b00_1000) ? 9'b1000_0001_0 : // Jr
    (opcode == 6'b00_0000 & funct == 6'b00_1001) ? 9'b1000_0011_0 : // Jalr
    (opcode == 6'b00_0000 & funct[5:1] == 5'b01100) ? 9'b1000_0000_0 : // mult
    (opcode == 6'b00_0000 & funct[5:1] == 5'b01101) ? 9'b1000_0000_0 : // div
    (opcode == 6'b00_0000 & funct[5:2] == 4'b0100 & funct[0] == 1) ? 9'b1000_0000_0 : // mthi & mtlo
    (opcode == 6'b00_0000) ? 9'b1000_0010_0 : // R-type
    (opcode[5:3] == 3'b001) ? 9'b0100_0010_0 : // I-type
    // (opcode[5:3] == 3'b101) ? 9'b0100_1000_0 : // store
    // (opcode[5:3] == 3'b100) ? 9'b0110_1110_0 : // load
    
    // store
    ((opcode[5:1] == 5'b10100) | (opcode == 6'b10_1011)) ? 
    9'b0100_1000_0 : 
    // load
    ((opcode[5:1] == 5'b10000) | (opcode[5:1] == 5'b10010) | (opcode == 6'b100011)) 
    ? 9'b0110_1110_0 :

    ((opcode == 6'b000001) & rt[4]) ? 9'b1001_0010_0 : // branch and link
    ((opcode[5:2] == 4'b0001) | (opcode == 6'b000001)) ? 9'b1001_0000_0 : // branch
    (opcode == 5'b00_0010) ? 9'b1000_0001_0 : // j
    (opcode == 5'b00_0011) ? 9'b1000_0011_0 : // jal
    9'b0000_0000_1;                                          // default
    
    // unused signal
    assign Link = (opcode == 6'b00_0000 & funct == 6'b00_1001) |    //jalr
                  (opcode == 6'b00_0011);                           // jal
    assign JumpV = (opcode == 6'b00_0000 & funct[5:1] == 5'b00100);   // jr & jalr


endmodule
