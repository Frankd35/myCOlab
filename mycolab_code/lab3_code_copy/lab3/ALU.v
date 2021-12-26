`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/22 13:17:14
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] in0,
    input [31:0] in1,
    input [2:0] alucontrol,
    output [31:0] out,
    output zero,overflow
    );
    wire [32:0] extra;
    // combinational logic
    assign out = 
        (alucontrol == 3'b010) ? in0 + in1 : // add
        (alucontrol == 3'b110) ? in0 - in1 : // sub
        (alucontrol == 3'b000) ? in0 & in1 : // and
        (alucontrol == 3'b001) ? in0 | in1 : // or
        (alucontrol == 3'b111) ? (in0 < in1 ? 1 : 0) : // slt
        32'hffff_fff0;                                             // default
        
    assign zero = (out == 0) ? 1 : 0;
    assign extra = 
    (alucontrol == 3'b010) ? {in0[31],in0} + {in1[31],in1} : 
    (alucontrol == 3'b110) ? {in0[31],in0} - {in1[31],in1} :
    0;
    
    assign overflow = extra[31] ^ extra[32];
    
endmodule
