`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/07 21:12:30
// Design Name: 
// Module Name: generalforward
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


module generalforward(
    input MEM_WB_MemWrite,EX_MEM_Mem2Reg,
    input [31:0] EX_MEM_ALUout,MEM_WB_ALUout,
    output siganl
    );
    
    assign signal = MEM_WB_MemWrite & EX_MEM_Mem2Reg & (EX_MEM_ALUout == MEM_WB_ALUout);
endmodule
