`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 10:58:03
// Design Name: 
// Module Name: mips
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


module mips(
	input wire clk,rst,
	output wire[31:0] PCout,
	input wire[31:0] instr,
	output wire memwrite,
	output wire[31:0] aluout,writedata,
	input wire[31:0] readdata 
    );
	
	wire Mem2Reg,ALUsrc,RegDst,RegWrite,Jump,PCsrc,zero,overflow;
	wire[7:0] alucontrol;

	Controller c(instr[31:26],instr[5:0],zero,alucontrol,
		PCsrc, RegWrite, memwrite, MemRead,RegDst, ALUsrc, Mem2Reg, Beq, Jump);

	datapath dp(clk,rst,Mem2Reg,PCsrc,ALUsrc,
		RegDst,RegWrite,Jump,alucontrol,overflow,zero,PCout,instr,aluout,writedata,readdata
		    ,RegWriteData
);
	
endmodule
