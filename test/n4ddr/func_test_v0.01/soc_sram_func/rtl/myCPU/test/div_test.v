`timescale 1ns / 1ps
`include "defines.vh"
`include "defines2.vh"

module usigned_div_sim();
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
        A = 32'hffff_fffd;
        B = 32'd2;
        #10
        sclr = 0;
        alucontrol = `EXE_DIV_OP;
        
        #10 alucontrol = 0;
        #380
        B = 32'hffff_fff0;
        alucontrol = `EXE_DIVU_OP;
        #10 alucontrol = 0;
        #390
        A = 32'd255;
        B = 32'd16;
        alucontrol = `EXE_DIV_OP;
        #10 alucontrol = 0;
        #390
        alucontrol = `EXE_DIVU_OP;

    end

    DU mu(
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