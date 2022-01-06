`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/22 20:25:45
// Design Name: 
// Module Name: Mux
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


module Mux #(parameter MSB = 31)
    (
    input [MSB:0] in0,
    input [MSB:0] in1,
    input signal,
    output [MSB:0] out
    );
    
    assign out = signal ? in1 : in0;
    
endmodule
