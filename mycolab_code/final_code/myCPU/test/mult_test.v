`timescale 1ns / 1ps
`include "defines.vh"
`include "defines2.vh"

module usigned_multiplier_sim();
    reg clk = 1;
    reg sclr = 1;
    reg [31:0] A,B;
    reg [7:0] alucontrol;

    wire [63:0] P;
    wire result_ok;
    always  begin
        #5
        clk = !clk;    
    end

    initial begin
        
        alucontrol = 0;        
        A = 32'hffff_fffe;
        B = 32'd4;
        #10
        sclr = 0;
        alucontrol = `EXE_MULT_OP;
        
        #10 alucontrol = 0;
        #90
        alucontrol = `EXE_MULTU_OP;
        #10 alucontrol = 0;
        #90
        A = 32'd2;
        alucontrol = `EXE_MULT_OP;
        #10 alucontrol = 0;
        #90
        alucontrol = `EXE_MULTU_OP;

    end

    MU mu(
        ~clk,sclr,
        A,B,
        alucontrol,
        result_ok,
        P
    );
endmodule


// 6个周期之后才会输出
// SCLR上升沿触发，重新开始乘法计算,即SCLR过后六个周期输出结果
// 流水输入