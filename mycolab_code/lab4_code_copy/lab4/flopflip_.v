`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/08 16:54:25
// Design Name: 
// Module Name: flopflip_
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


module flopflip_#(parameter MSB = 31)
    (
        input clk,rst,en,
        input [MSB:0] in,
        output [MSB:0] out
    );
    reg [MSB:0] r = 0;
    reg [MSB:0] q = 0;
    
    always @(negedge clk) begin
    if (rst) begin
        r = 0; q = 0;
        end 
    else begin
        r = en ? in : r;
        end
    end
    
    always @(posedge clk)
        q = r;
    assign out = q;
endmodule
