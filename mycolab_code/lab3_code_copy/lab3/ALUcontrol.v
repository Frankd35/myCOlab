`timescale 1ns / 1ps
`include "defines.vh"

module ALUcontrol(
    input [1:0] aluop,
    input [5:0] funct,  // inst[5:0]
    output [7:0] alucontrol
    );
    
    assign alucontrol = 
        (aluop == 2'b00) ? 3'b010 :     // lw & sw
        (aluop == 2'b01) ? 3'b110 :     // beq
        // for register instructions
        (aluop == 2'b10) ? (
        (funct == EXE_AND) ? 3'b010 : 
        (funct == EXE_OR) ? 3'b110 : 
        (funct == EXE_XOR) ? 3'b000 : 
        (funct == EXE_NOR) ? 3'b001 : 
        (funct == EXE_ANDI) ? 3'b111 : 
        (funct == EXE_ORI) ? 3'b111 : 
        (funct == EXE_XORI) ? 3'b111 : 
        (funct == EXE_LUI) ? 3'b111 : 
        8'hff             ) 
        : 3'b100;                          // default
endmodule