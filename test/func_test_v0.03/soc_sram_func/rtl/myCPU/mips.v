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
	input wire[31:0] readdata,
	output [3:0] wea,
	output [31:0] debug_wb_pc,
    output [3:0] debug_wb_rf_wen,
    output [4:0] debug_wb_rf_wnum,
    output [31:0] debug_wb_rf_wdata
    );
	
	wire [39:0] ASCII;
	instdec dec(instr,ASCII);

	wire Mem2Reg,ALUsrc,RegDst,RegWrite,Jump,PCsrc,zero,overflow;
	


	datapath dp(clk,rst,overflow,zero,memwrite,PCout,instr,aluout,writedata,readdata,wea,
				debug_wb_pc,debug_wb_rf_wen,debug_wb_rf_wnum,debug_wb_rf_wdata
				);
	
endmodule
