`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/02 14:20:09
// Design Name: 
// Module Name: regfile
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


module regfile(
	input wire clk,rst,
	input wire we3,    // RegWrite signal
	input wire[4:0] ra1,ra2,wa3,   // 
	input wire[31:0] wd3,
	output wire[31:0] rd1,rd2
    );
    integer i = 0;
	reg [31:0] rf[31:0];

    

	always @(negedge clk) begin
	    if(rst) begin
	       for(i = 0; i < 32; i = i + 1) begin
	           rf[i] <= 0;
	       end
	    end
		else if(we3) begin
			 rf[wa3] <= wd3;
		end
	end

	assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
	assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
	
endmodule
