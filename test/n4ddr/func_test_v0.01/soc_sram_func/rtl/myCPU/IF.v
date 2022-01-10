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
    input exp_handle,ERET,
    input [31:0] PCadd4,
    input [31:0] jumpAddr,
    input [31:0] branchAddr,epc,
    output [31:0] PCout,
    output PC_EXP
    );
    wire [31:0] PCin,PCoutAdd4;
    
    assign PCoutAdd4 = PCout+4;

    assign PCin = exp_handle ? 32'hbfc0_0380 :      // best priority
                  ERET ? epc :
                  jump ? jumpAddr :
                  branch ? branchAddr :
                  PCoutAdd4;

    assign PC_EXP = ~(PCout[1:0] == 2'b00);
    
        
    PC pc(
    .clk(clk),
    .rst(rst),  
    .en(~stall | exp_handle),       // exception has higher priority than stall
    .inst_addr(PCin),
    .addr(PCout)
    );
    
   
   
endmodule
