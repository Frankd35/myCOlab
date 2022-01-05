`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/04 09:56:13
// Design Name: 
// Module Name: IF
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


module IF(
    input clk,
    input rst,
    input stall,
    input branch,
    input jump, 
    input [31:0] PCadd4,
    input [31:0] jumpAddr,
    input [31:0] branchAddr,
    output [31:0] PCout
    );
    wire [31:0] PCin,PCoutAdd4;
    
    assign PCoutAdd4 = PCout+4;
    Mux3 pcin(
    .in0(PCoutAdd4),
    .in1(branchAddr),
    .in2(jumpAddr),
    .signal({jump,branch}),
    .out(PCin)
    );
        
    PC pc(
    .clk(clk),
    .rst(rst),  // ͬ����λ
    .en(~stall),
    .inst_addr(PCin),
    .addr(PCout)
    );
    
   
   
endmodule
