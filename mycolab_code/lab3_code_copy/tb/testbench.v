`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 13:54:42
// Design Name: 
// Module Name: testbench
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


module testbench();
	reg clk;
	reg rst;

	wire[31:0] writedata,dataadr,pc,instr;
	wire memwrite;
    wire [39:0] ascii;    
    wire [4:0] rs,rt,rd;
    assign rs = instr[25:21];
    assign rt = instr[20:16];
    assign rd = instr[15:11];
	top dut(clk,rst,writedata,dataadr,pc,instr,memwrite);
    instdec decode(instr,ascii);
	initial begin 
		rst <= 1;
		#200;
		rst <= 0;
	end

	always begin
		clk <= 1;
		#10;
		clk <= 0;
		#10;
	
	end

	// always @(negedge clk) begin
	// 	if(memwrite) begin
	// 		/* code */
	// 		if(dataadr === 84 & writedata === 7) begin
	// 			/* code */
	// 			$display("Simulation succeeded");
	// 			$stop;
	// 		end else if(dataadr !== 80) begin
	// 			/* code */
	// 			$display("Simulation Failed");
	// 			$stop;
	// 		end
	// 	end
	// end
endmodule
