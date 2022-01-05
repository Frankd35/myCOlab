`timescale 1ns / 1ps

module PC (
    input clk,
    input rst,  // ͬ����λ
    input en,
    input [31:0] inst_addr,
    output [31:0] addr
    );
    
    reg [31:0] addr = 32'hbfbf_fffc;
    
    always @(posedge clk) begin
        if(rst) 
            addr = 32'hbfbf_fffc;
        else
           addr = en ? inst_addr : addr;
    end
    
    //assign addr = rst ? 0 : inst_addr;
endmodule   