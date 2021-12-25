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
    input ALUsrc,
    input RegDst,
    input [2:0] ID_EX_alucontrol,
    input [3:0] forwardSignal,  // [3:2] for Reg[rs] and [1:0] for Reg[rt]
    input [31:0] ID_EX_RegReadData1,ID_EX_RegReadData2,ID_EX_immediate,
    input [31:0] EX_MEM_aluout,WBvalue,
    input [4:0] ID_EX_Rt,ID_EX_Rd,
    output [31:0] ALUout,
    output [31:0] forwardRtData,
    output [4:0] Rd_EX
    ,output [31:0] ALUin // test
    );
    
    
    // ALU source forward multiplexer
    wire [31:0] forwardRsData, forwardRtData,ID_EX_RegReadData1,ID_EX_RegReadData2;
    
    Mux3 muxRs(
    .in0(ID_EX_RegReadData1),
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
    
    
    wire [31:0] ALUin;
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
    
    // RegDst multiplexer
    Mux #(4) Mux_RegDst(
    .in0(ID_EX_Rt),
    .in1(ID_EX_Rd),
    .signal(RegDst),
    .out(Rd_EX)
    );
    
endmodule
