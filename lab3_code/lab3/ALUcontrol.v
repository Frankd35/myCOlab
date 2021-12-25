`timescale 1ns / 1ps

module ALUcontrol(
    input [1:0] aluop,
    input [5:0] funct,  // inst[5:0]
    output [2:0] alucontrol
    );
    
    assign alucontrol = 
        (aluop == 2'b00) ? 3'b010 :     // lw & sw
        (aluop == 2'b01) ? 3'b110 :     // beq
        // for register instructions
        (aluop == 2'b10) ? (
        (funct == 6'b10_0000) ? 3'b010 : // addition
        (funct == 6'b10_0010) ? 3'b110 : // subtrction
        (funct == 6'b10_0100) ? 3'b000 : // logical and
        (funct == 6'b10_0101) ? 3'b001 : // logical or
        (funct == 6'b10_1010) ? 3'b111 : // set on less than
        3'b100              ) 
        : 3'b100;                          // default
endmodule