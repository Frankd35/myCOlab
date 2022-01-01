`timescale 1ns / 1ps
`include "defines.vh"
`include "defines2.vh"

module MU (
    input clk,sclr,
    input [31:0] in0,in1,
    input [7:0] alucontrol,
    output result_ok,
    output [63:0] result
);
    wire [31:0] A,B;
    wire [63:0] P;
    reg sign = 0;
    reg [3:0] count = 0;

    always @(posedge clk) begin
        if(alucontrol == `EXE_MULT_OP)begin
            count <= 0;
            sign <= in0[31] ^ in1[31];            
        end else if (alucontrol == `EXE_MULTU_OP)begin
            count <= 0;
            sign <= 0;
        end

        if (sclr)begin
            count <= 0;
        end else if (count == 6)begin
            count <= 0;
            sign <= 0;
        end else begin
            count <= count + 1;
        end
    end

    assign result_ok = (count == 6);
    assign A = in0[31] & (alucontrol == `EXE_MULT_OP) ? (~in0 + 1) : in0;
    assign B = in1[31] & (alucontrol == `EXE_MULT_OP) ? (~in1 + 1) : in1;

    assign result = sign ? (~P + 1) : P;

    mult_gen_0 multiplier (
    .CLK(clk),    // input wire CLK
    .A(A),        // input wire [31 : 0] A
    .B(B),        // input wire [31 : 0] B
    .SCLR(sclr),  // input wire SCLR
    .P(P)        // output wire [63 : 0] P
    );




endmodule