`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/07 23:02:13
// Design Name: 
// Module Name: hazard
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


module hazard(
    input branch,jump,result_notok,
    input ID_EX_RegWrite,
    input EX_MEM_Mem2Reg,
    input ID_EX_Mem2Reg,
    input [4:0] IF_ID_Rs,
    input [4:0] IF_ID_Rt,
    input [4:0] Rd_EX,
    input [4:0] EX_MEM_Rd,
    output stall_IF, stall_ID, stall_EX
    );
    
    assign stall_IF = stall_ID;

    assign stall_ID = stall_EX |
    // for branch following R-type or lw
    ( branch & ID_EX_RegWrite & (IF_ID_Rs == Rd_EX | IF_ID_Rt == Rd_EX)) |  
    // for branch following lw(two circle)
    ( branch & EX_MEM_Mem2Reg & (IF_ID_Rs == EX_MEM_Rd | IF_ID_Rt == EX_MEM_Rd)) |
    // for read the register data after a lw using it
    (ID_EX_Mem2Reg & (IF_ID_Rs == Rd_EX | IF_ID_Rt == Rd_EX));

    assign stall_EX = result_notok;    // wait for mult & div

endmodule
