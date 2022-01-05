`timescale 1ns / 1ps
`include "defines.vh"
`include "defines2.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/22 13:17:14
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] in0,
    input [31:0] in1,
    input [4:0] shamt,
    input [7:0] alucontrol,
    output [31:0] out,
    output zero,overflow
    );
    wire [32:0] extra;

    // combinational logic
    always @(*) begin
		case (alucontrol)
			// 逻辑指令[无立即数]功能实现
			`EXE_AND_OP: y <= nums1 & nums2;
			`EXE_OR_OP:	 y <= nums1 | nums2;
			`EXE_XOR_OP: y <= nums1 ^ nums2;
			`EXE_NOR_OP: y <= ~(nums1 | nums2);
			// 逻辑指令[有立即数]，需要进 ?0符号扩展修改
			`EXE_ANDI_OP: y <= nums1 & {{16{1'b0}},nums2[15:0]};
			`EXE_XORI_OP: y <= nums1 ^ {{16{1'b0}},nums2[15:0]};
			`EXE_ORI_OP: y <= nums1 | {{16{1'b0}},nums2[15:0]};
			`EXE_LUI_OP: y <= {nums2[15:0],{16{1'b0}}}; //将低16位置0
			// 移位指令
			`EXE_SLL_OP: y <= nums2 << sa; //将rt的 ? 左移sa
			`EXE_SRL_OP: y <= nums2 >> sa; //将rt的 ? 右移sa
			`EXE_SRA_OP: y <= $signed (nums2) >>> sa; //注意这里用到>>>算术右移指令，在高位补符号位，但是需要保证nums2 ?定是符号扩展 ?
			`EXE_SLLV_OP: y <= nums2 << nums1[4:0]; //只需要低5 ?
			`EXE_SRLV_OP: y <= nums2 >> nums1[4:0];
			`EXE_SRAV_OP: y <= $signed (nums2) >>> nums1[4:0];
			// 数据移动指令
			`EXE_MFHI_OP: y <= hi; //从hi寄存器取
			`EXE_MFLO_OP: y <= lo; //从lo寄存器取
			`EXE_MTHI_OP: y <= nums1; //写到hi寄存器中
			`EXE_MTLO_OP: y <= nums1; //写到lo寄存器中
			// 算术运算指令
			`EXE_ADD_OP: y <= nums1 + nums2;
			`EXE_ADDI_OP: y <= nums1 + nums2;
			`EXE_ADDU_OP: y <= nums1 + nums2;
			`EXE_ADDIU_OP: y <= nums1 + nums2;
			`EXE_SUBU_OP: y <= nums1 - nums2;
			`EXE_SUB_OP: /*begin nums2_not = -nums2;y = nums2 + nums1; end*/y <= nums1 - nums2;
			`EXE_SLT_OP: y <= ($signed (nums1) <  $signed (nums2) ) ;  //SLT是有符号数的比较，传进来的应该是有符号，但是为了保证准确性还是强制用$signed()函数
			`EXE_SLTU_OP: y <= nums1 < nums2;
			`EXE_SLTI_OP: y <= ($signed (nums1) <  $signed (nums2) );
			`EXE_SLTIU_OP: y <= nums1 < nums2;

			// 存取指令，输出的直接就是在mem阶段 ?要访问存储器的地 ?
			// 不同访存指令的区别仅仅在于读取字节不 ? ?
            `EXE_LB_OP:y <= nums1 + nums2;
            `EXE_LBU_OP:y <= nums1 + nums2;
            `EXE_LH_OP:y <= nums1 + nums2;
            `EXE_LHU_OP:y <= nums1 + nums2;
            `EXE_LW_OP:y <= nums1 + nums2;
            `EXE_SB_OP:y <= nums1 + nums2;
            `EXE_SH_OP:y <= nums1 + nums2;
            `EXE_SW_OP:y <= nums1 + nums2;

			default : y <= 32'b0;
		endcase	
	end

    
    assign zero = (out == 0) ? 1 : 0;

    // double signed bit
    assign extra = 
    ((alucontrol == `ADD) | (alucontrol == `ADDI)) ? {in0[31],in0} + {in1[31],in1} : 
    (alucontrol == `SUB)? {in0[31],in0} - {in1[31],in1} :
    0;
    
    assign overflow = extra[31] ^ extra[32];
    
    wire [31:0] y,nums1,nums2;

endmodule
