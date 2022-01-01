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

    ,input [31:0] RegAddr,output [31:0] regout ,
    input memCheck,
    input [31:0]memAddr
    );
	
	wire Mem2Reg,ALUsrc,RegDst,RegWrite,Jump,PCsrc,zero,overflow;
	wire[2:0] alucontrol;

	//Controller c(instr[31:26],instr[5:0],zero,alucontrol,
		//PCsrc, RegWrite, memwrite, MemRead,RegDst, ALUsrc, Mem2Reg, Beq, Jump);
	datapath dp(clk,rst,overflow,zero,memwrite,PCout,instr,aluout,writedata,readdata

    ,RegAddr,regout
);
	
endmodule
