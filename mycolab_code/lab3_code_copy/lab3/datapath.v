`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/23 13:51:23
// Design Name: 
// Module Name: datapath
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


module datapath(
    input clk,rst,Mem2Reg,PCsrc,ALUsrc,RegDst,RegWrite,Jump,ShiftI,    // control signals 
    input [7:0] alucontrol, // control signals 
    output overflow,zero,   // ALU output signal
    output [31:0] PCout,    // instruction address
    input [31:0] inst,     // instruction
    output [31:0] aluout,   // ALU result
    output [31:0] writedata,    // from register to data memory
    input [31:0] readdata       // data memory readdata
    ,output [31:0] RegWriteData
    );
    wire [4:0] RegWriteAddr;
    wire [31:0] RegReadData1,RegReadData2,RegWriteData,immediate;  // data buses
    wire [31:0] ALUin0,ALUin1,aluout;
    wire [31:0] PCin,PCout,imoffset,branchAddr,PCAdd4,NewAddr,jumpAddr;
    
    Mux #(.MSB(4)) mux0(.in0(inst[20:16]),.in1(inst[15:11]),.signal(RegDst),.out(RegWriteAddr));   // RegDst
    Mux mux_shift_imm(.in0(RegReadData1),.in1({27'b0,inst[10:6]}),.signal(ShiftI),.out(ALUin0));   // ALUsrc0
    Mux mux1(.in0(RegReadData2),.in1(immediate),.signal(ALUsrc),.out(ALUin1));   // ALUsrc1
    Mux mux2(.in0(aluout),.in1(readdata),.signal(Mem2Reg),.out(RegWriteData));   // Mem2Reg
    Mux mux3(.in0(PCAdd4),.in1(branchAddr),.signal(PCsrc),.out(NewAddr));        // PCsrc
    Mux mux4(.in0(NewAddr),.in1(jumpAddr),.signal(Jump),.out(PCin));         // Jump
    
    regfile register(
    .clk(clk),
	.we3(RegWrite),
	.ra1(inst[25:21]),
	.ra2(inst[20:16]),
	.wa3(RegWriteAddr),
	.wd3(RegWriteData),
	.rd1(RegReadData1),
	.rd2(RegReadData2)
    );
    
    ALU alu(
    .in0(ALUin0),
    .in1(ALUin1),
    .alucontrol(alucontrol),
    .out(aluout),
    .zero(zero),
    .overflow(overflow)
    );
    
    sign_extend extend(.in(inst[15:0]),.out(immediate));
    
    PC pc(
    .clk(clk),
    .rst(rst),  
    .inst_addr(PCin),
    .addr(PCout)
    );
    
    Adder PC4(PCout,32'd4,PCAdd4);
    sl2 shift0(.in(immediate),.out(imoffset));
    Adder branchTarget(PCAdd4,imoffset,branchAddr);
    sl2 shift1(.in({6'b000000,inst[25:0]}),.out(jumpAddr));
    
    assign writedata = RegReadData2;
endmodule
