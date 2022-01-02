`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/07 17:13:57
// Design Name: 
// Module Name: EX
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


module EX(
    input clk,rst,ALUsrc,
    input RegDst,ID_EX_ShiftI,
    input [7:0] ID_EX_alucontrol,
    input [3:0] forwardSignal,  // [3:2] for Reg[rs] and [1:0] for Reg[rt]
    input [31:0] ID_EX_RegReadData1,ID_EX_RegReadData2,ID_EX_immediate,
    input [31:0] EX_MEM_aluout,WBvalue,
    input [4:0] ID_EX_Rt,ID_EX_Rd,ID_EX_shamt,
    output [31:0] out,
    output [31:0] forwardRtData,
    output [4:0] Rd_EX,
    output result_notok
    );
    
    
    // ALU source forward multiplexer
    wire [31:0] tmp,forwardRsData,forwardRtData,ID_EX_RegReadData1,ID_EX_RegReadData2,ALUin,hilo_out,ALUout;
    wire [63:0] mul_result,div_result,to_hilo;
    wire result_notok,mult_result_ok,div_result_ok;

    assign tmp = ID_EX_ShiftI ? {27'b0,ID_EX_shamt} : ID_EX_RegReadData1;

    Mux3 muxRs(
    .in0(tmp),
    .in1(EX_MEM_aluout),
    .in2(WBvalue),
    .signal(forwardSignal[3:2]),
    .out(forwardRsData)
    );
    
    Mux3 muxRt(
    .in0(ID_EX_RegReadData2),
    .in1(EX_MEM_aluout),
    .in2(WBvalue),
    .signal(forwardSignal[1:0]),
    .out(forwardRtData)
    );
    
    
    // ALUsrc multiplexer
    Mux Mux_ALUsrc(
    .in0(forwardRtData),
    .in1(ID_EX_immediate),
    .signal(ALUsrc),
    .out(ALUin)
    );
    
    // ALU
    ALU alu(
    .in0(forwardRsData),
    .in1(ALUin),
    .alucontrol(ID_EX_alucontrol),
    .out(ALUout),
    .zero(),.overflow() // do no use
    );
    
    // MU
    MU mu(
    .clk(~clk),
    .sclr(rst),
    .in0(forwardRsData),
    .in1(ALUin),
    .alucontrol(ID_EX_alucontrol),
    .result_ok(mult_result_ok),
    .result(mul_result)     // unused，添加hilo
    );

    // DU
    DU du(
    .clk(~clk),
    .sclr(rst),
    .dividend(forwardRsData),
    .divisor(ALUin),
    .alucontrol(ID_EX_alucontrol),
    .result_ok(div_result_ok),
    .result(div_result)     
    );


    // RegDst multiplexer
    Mux #(4) Mux_RegDst(
    .in0(ID_EX_Rt),
    .in1(ID_EX_Rd),
    .signal(RegDst),
    .out(Rd_EX)
    );


    assign to_hilo = mult_result_ok ? mul_result : (div_result_ok ? div_result : 0);
    // hilo register
    hilo Hilo(
    .clk(clk),.rst(rst),
    .regin(forwardRsData),
    .result(to_hilo),
    .alucontrol(ID_EX_alucontrol),
    .result_ok(mult_result_ok | div_result_ok),
    .hilo_out(hilo_out)
    );

    assign out = ((ID_EX_alucontrol == `EXE_MFHI_OP) | (ID_EX_alucontrol == `EXE_MFLO_OP)) ? hilo_out : ALUout;
    assign result_notok = (((ID_EX_alucontrol == `EXE_MULT_OP) | (ID_EX_alucontrol == `EXE_MULTU_OP)) & (~mult_result_ok)) |
                            (((ID_EX_alucontrol == `EXE_DIV_OP) | (ID_EX_alucontrol == `EXE_DIVU_OP)) & (~div_result_ok));


endmodule
