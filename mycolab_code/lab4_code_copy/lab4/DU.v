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
    wire data_ready;
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
            state <= idle;
            sign <= 0;
        end else if (state == idle) begin
            state <= next_state;
            sign <= (alucontrol == `EXE_DIV_OP) & (divisor[31] ^ dividend[31]);
        end else  begin
            state <= next_state;
        end
    end

    assign data_ready = (state == idle) & (next_state == lock);

    assign A = divisor[31] & (alucontrol == `EXE_DIV_OP) ? (~divisor + 1) : divisor;
    assign B = dividend[31] & (alucontrol == `EXE_DIV_OP) ? (~dividend + 1) : dividend;

    assign result = sign ? {(~P[31:0] + 1),(~P[63:32] + 1)} : {P[31:0],P[63:0]};

    div_gen_0 div_unit (
    .aclk(clk),                                            // input wire aclk
    .aresetn(sclr),                                        // input wire aresetn
    .s_axis_divisor_tvalid(state),                    // input wire s_axis_divisor_tvalid
    .s_axis_divisor_tready(s_axis_divisor_tready),         // output wire s_axis_divisor_tready
    .s_axis_divisor_tdata(A),                        // input wire [31 : 0] s_axis_divisor_tdata
    .s_axis_dividend_tvalid(data_ready),                   // input wire s_axis_dividend_tvalid
    .s_axis_dividend_tready(s_axis_dividend_tready),        // output wire s_axis_dividend_tready
    .s_axis_dividend_tdata(B),                       // input wire [31 : 0] s_axis_dividend_tdata
    .m_axis_dout_tvalid(result_ok),                         // output wire m_axis_dout_tvalid
    .m_axis_dout_tdata(P)                                   // output wire [63 : 0] m_axis_dout_tdata
    );



endmodule