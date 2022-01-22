`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/04 00:36:42
// Design Name: 
// Module Name: flopflip
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


module flopflip #(parameter MSB = 31)
    (
        input clk,rst,en,
        input [MSB:0] in,
        output [MSB:0] r
    );
    reg [MSB:0] r = 0;
    
    always @(posedge clk) begin
    if (rst) begin
        r = 0;
        end 
    else begin
        r = en ? in : r;
        end
    end
    
endmodule
