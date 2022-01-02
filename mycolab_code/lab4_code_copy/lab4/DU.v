`timescale 1ns / 1ps
`include "defines.vh"
`include "defines2.vh"

module DU (
    input clk,sclr,
    input [31:0] divisor,dividend,
    input [7:0] alucontrol,
    output result_ok,
    output [63:0] result
); 
    wire [31:0] A,B;
    wire [63:0] P;
    wire data_ready,stall;
    reg [5:0] count = 0;
    reg sign = 0;
    reg state = 0;
    reg next_state = 0;
    // FSM state
    parameter idle = 0, lock = 1;

    
    always @(*) begin
        if(state == idle)
            next_state = (alucontrol == `EXE_DIV_OP) | (alucontrol == `EXE_DIVU_OP);
        else 
            next_state = result_ok ? idle : lock;
    end

    always @(posedge clk) begin
        if (sclr) begin
            count <= 0;
            state <= idle;
            sign <= 0;
        end else if (state == idle) begin
            count <= 0;
            state <= next_state;
            sign <= (alucontrol == `EXE_DIV_OP) & (divisor[31] ^ dividend[31]);
        end else  begin
            count <= count + 1;
            state <= next_state;
        end
    end

    assign data_ready = (state == idle) & (next_state == lock);
    assign result_ok = (count == 32);
    assign A = divisor[31] & (alucontrol == `EXE_DIV_OP) ? (~divisor + 1) : divisor;
    assign B = dividend[31] & (alucontrol == `EXE_DIV_OP) ? (~dividend + 1) : dividend;

    assign result = sign ? {(~P[31:0] + 1),(~P[63:32] + 1)} : {P[31:0],P[63:0]};

    div_radix2 div(
    clk,
    sclr,
    B,  //dividend
    A,  //divisor
    data_ready,
    0,   //1:signed
    stall,
    P    
    );



endmodule