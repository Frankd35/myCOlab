`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/07 20:20:56
// Design Name: 
// Module Name: forwardunit
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


module forwardunit(
    input EX_MEM_RegWrite,
    input EX_MEM_Mem2Reg,
    input MEM_WB_RegWrite,
    input [4:0] EX_MEM_Rd, 
    input [4:0] MEM_WB_Rd,
    input [4:0] rs,
    input [4:0] rt,
    output [1:0] rscontrol,
    output [1:0] rtcontrol
    );
    
    assign rscontrol = EX_MEM_RegWrite & (!EX_MEM_Mem2Reg) & (rs != 0 & rs == EX_MEM_Rd) ? 2'b01 :
    MEM_WB_RegWrite & (rs != 0 & rs == MEM_WB_Rd) ? 2'b10 : 2'b00;
    
    assign rtcontrol = EX_MEM_RegWrite & (!EX_MEM_Mem2Reg) & (rt != 0 & rt == EX_MEM_Rd) ? 2'b01 :
    MEM_WB_RegWrite & (rt != 0 & rt == MEM_WB_Rd) ? 2'b10 : 2'b00;
endmodule
