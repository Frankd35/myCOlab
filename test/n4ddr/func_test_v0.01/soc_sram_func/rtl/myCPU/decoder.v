`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/08 19:58:17
// Design Name: 
// Module Name: decoder
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


module decoder(
    input [4:0] data_in,
    output [31:0] data_out
    );
    reg data_out = 0;
    always@(data_in)
		 begin
		      if(1)  
				   begin
					    case(data_in)
						     5'b0_0000 : data_out = 32'b0000_0000_0000_0000_0000_0000_0000_0001 ;
							 5'b0_0001 : data_out = 32'b0000_0000_0000_0000_0000_0000_0000_0010 ;
							 5'b0_0010 : data_out = 32'b0000_0000_0000_0000_0000_0000_0000_0100 ;
							 5'b0_0011 : data_out = 32'b0000_0000_0000_0000_0000_0000_0000_1000 ;
							 5'b0_0100 : data_out = 32'b0000_0000_0000_0000_0000_0000_0001_0000 ;
							 5'b0_0101 : data_out = 32'b0000_0000_0000_0000_0000_0000_0010_0000 ;
							 5'b0_0110 : data_out = 32'b0000_0000_0000_0000_0000_0000_0100_0000 ;
							 5'b0_0111 : data_out = 32'b0000_0000_0000_0000_0000_0000_1000_0000 ;
							 5'b0_1000 : data_out = 32'b0000_0000_0000_0000_0000_0001_0000_0000 ;
							 5'b0_1001 : data_out = 32'b0000_0000_0000_0000_0000_0010_0000_0000 ;
							 5'b0_1010 : data_out = 32'b0000_0000_0000_0000_0000_0100_0000_0000 ;
							 5'b0_1011 : data_out = 32'b0000_0000_0000_0000_0000_1000_0000_0000 ;
							 5'b0_1100 : data_out = 32'b0000_0000_0000_0000_0001_0000_0000_0000 ;
							 5'b0_1101 : data_out = 32'b0000_0000_0000_0000_0010_0000_0000_0000 ;
							 5'b0_1110 : data_out = 32'b0000_0000_0000_0000_0100_0000_0000_0000 ;
							 5'b0_1111 : data_out = 32'b0000_0000_0000_0000_1000_0000_0000_0000 ;
							 5'b1_0000 : data_out = 32'b0000_0000_0000_0001_0000_0000_0000_0000 ;
							 5'b1_0001 : data_out = 32'b0000_0000_0000_0010_0000_0000_0000_0000 ;
							 5'b1_0010 : data_out = 32'b0000_0000_0000_0100_0000_0000_0000_0000 ;
							 5'b1_0011 : data_out = 32'b0000_0000_0000_1000_0000_0000_0000_0000 ;
							 5'b1_0100 : data_out = 32'b0000_0000_0001_0000_0000_0000_0000_0000 ;
							 5'b1_0101 : data_out = 32'b0000_0000_0010_0000_0000_0000_0000_0000 ;
							 5'b1_0110 : data_out = 32'b0000_0000_0100_0000_0000_0000_0000_0000 ;
							 5'b1_0111 : data_out = 32'b0000_0000_1000_0000_0000_0000_0000_0000 ;
							 5'b1_1000 : data_out = 32'b0000_0001_0000_0000_0000_0000_0000_0000 ;
							 5'b1_1001 : data_out = 32'b0000_0010_0000_0000_0000_0000_0000_0000 ;
							 5'b1_1010 : data_out = 32'b0000_0100_0000_0000_0000_0000_0000_0000 ;
							 5'b1_1011 : data_out = 32'b0000_1000_0000_0000_0000_0000_0000_0000 ;
							 5'b1_1100 : data_out = 32'b0001_0000_0000_0000_0000_0000_0000_0000 ;
							 5'b1_1101 : data_out = 32'b0010_0000_0000_0000_0000_0000_0000_0000 ;
							 5'b1_1110 : data_out = 32'b0100_0000_0000_0000_0000_0000_0000_0000 ;
							 5'b1_1111 : data_out = 32'b1000_0000_0000_0000_0000_0000_0000_0000 ;
							 default   : data_out = 32'b0000_0000_0000_0000_0000_0000_0000_0000 ;
                   endcase
						 end
			 else                  data_out = 32'b0000_0000_0000_0000_0000_0000_0000_0000 ;
					
					

		 
		 end
endmodule