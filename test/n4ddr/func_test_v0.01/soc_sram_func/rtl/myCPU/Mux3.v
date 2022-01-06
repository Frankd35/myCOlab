`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/03 23:46:15
// Design Name: 
// Module Name: Mux3
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


module Mux3 #(parameter MSB = 31)
    (
    input [MSB:0] in0,
    input [MSB:0] in1,
    input [MSB:0] in2,
    input [1:0] signal,
    output [MSB:0] out
    );
    
    assign out = 
    (signal == 0) ? in0 :
    (signal == 1) ? in1 :
    (signal == 2) ? in2 : 
    0; // defualt
endmodule
