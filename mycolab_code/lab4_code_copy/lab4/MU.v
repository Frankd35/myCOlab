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
    // reg [7:0] alucontrol;
    reg [3:0] count = 0;
    reg sign = 0;
    reg state = 0;
    reg next_state = 0;
    // FSM state
    parameter idle = 0, lock = 1;

    
    always @(*) begin
        if(state == idle)
            next_state = (alucontrol == `EXE_MULT_OP) | (alucontrol == `EXE_MULTU_OP);
        else 
            next_state = result_ok ? idle : lock;
    end

    always @(posedge clk) begin
        // if (sclr) begin
        //     count <= 0;
        //     state <= idle;
        //     sign <= (alucontrol == `EXE_MULT_OP) & (in0[31] ^ in1[31]);
        // end

        if (state == idle) begin
            count <= 0;
            state <= next_state;
            sign <= (alucontrol == `EXE_MULT_OP) & (in0[31] ^ in1[31]);
        end else  begin
            count <= count + 1;
            state <= next_state;
        end

    end



    assign result_ok = (count == 5);
    assign A = in0[31] & (alucontrol == `EXE_MULT_OP) ? (~in0 + 1) : in0;
    assign B = in1[31] & (alucontrol == `EXE_MULT_OP) ? (~in1 + 1) : in1;

    assign result = sign ? (~P + 1) : P;

    mult_gen_0 multiplier (
    .CLK(clk),    // input wire CLK
    .A(A),        // input wire [31 : 0] A
    .B(B),        // input wire [31 : 0] B
    .SCLR(0),  // input wire SCLR
    .P(P)        // output wire [63 : 0] P
    );




endmodule