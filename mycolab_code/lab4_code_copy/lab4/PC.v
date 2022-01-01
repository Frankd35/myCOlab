`timescale 1ns / 1ps

module PC (
    input clk,
    input rst,  // Í¬²½¸´Î»
    input en,
    input [31:0] inst_addr,
    output [31:0] addr
    );
    
    reg [31:0] addr = 0;
    
    always @(negedge clk) begin
        if(rst) 
            addr = 0;
        else
           addr = en ? inst_addr : addr;
    end
    
    //assign addr = rst ? 0 : inst_addr;
endmodule