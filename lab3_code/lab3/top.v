`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 13:50:53
// Design Name: 
// Module Name: top
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


module top(
	input clk,rst,
	output [31:0] writedata,dataadr,
	output memwrite
	);
	// wire clk;
	wire[31:0] pc,instr,readdata,dataadr,writedata;
    wire memwrite;
	//   clk_div instance_name(
 //    	// Clock out ports
	//     .clk_out1(hclk),     // output clk_out1
	//    // Clock in ports
	//     .clk_in1(clk)
 //    	); 
   	

	mips mips(clk,rst,pc,instr,memwrite,dataadr,writedata,readdata);
	/*
	mips(
	input wire clk,rst,
	output wire[31:0] PCout,
	input wire[31:0] instr,
	output wire memwrite,
	output wire[31:0] aluout,writedata,
	input wire[31:0] readdata 
    );
	*/
	
	//inst_mem imem(clk,pc[7:2],instr);
	//data_mem dmem(clk,memwrite,dataadr,writedata,readdata);
	
	instruction_memory im (
    .clka(clk),    // input wire clka
    .addra(pc),  // input wire [6 : 0] addra
    .douta(instr)  // output wire [31 : 0] douta
    );

    data_memory dm (
    .clka(clk),    // input wire clka
    .wea(memwrite),      // input wire [0 : 0] wea
    .addra(dataadr),  // input wire [6 : 0] addra
    .dina(writedata),    // input wire [31 : 0] dina
    .douta(readdata)  // output wire [31 : 0] douta
    );

endmodule
