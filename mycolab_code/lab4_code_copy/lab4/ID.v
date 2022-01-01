`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/04 10:42:11
// Design Name: 
// Module Name: ID
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


module ID(
    input clk,
    input rst,
    input stall,
    input MEM_WB_RegWrite,
    input [4:0] MEM_WB_Rd,
    input [3:0] forwardSignal,  // [3:2] for Reg[rs] and [1:0] for Reg[rt]
    input [31:0] IF_ID_instr,IF_ID_PCout,WBvalue,EX_MEM_aluout,
    output Mem2Reg_ID,RegWrite_ID,MemWrite_ID,ALUsrc_ID,RegDst_ID,ShiftI_ID,
    output [7:0] alucontrol_ID,
    output branch,Beq,Jump,
    output [31:0] RegReadData1,RegReadData2,immediate,PCadd4,jumpAddr,branchAddr,
    output [4:0] Rs,Rt,Rd,shamt
    );    
    wire Mem2Reg,RegWrite,MemWrite,ALUsrc,RegDst,Beq,Jump,ShiftI,JumpV,Link;   // control signals
    wire [7:0] alucontrol;      // control signals
    
    
    // combinationl logicals for branchAddress and jumpAddress
    
    wire [31:0] PCadd4,immediate,offeset;

    // im[PC] = IF_ID_instr; IF_ID_PCout = PC + 4
    Adder pcadd4(IF_ID_PCout,4,PCadd4);
    sl2 shiftleft({6'b000000,IF_ID_instr[25:0]},jumpAddr);
    sl2 shiftleft2(immediate,offeset);
    Adder branchAddrAdder(IF_ID_PCout,offeset,branchAddr);
    
    
    // regfile 
    regfile Reg(
    .clk(clk),
    .we3(MEM_WB_RegWrite),    // RegWrite signal
    .ra1(IF_ID_instr[25:21]),
    .ra2(IF_ID_instr[20:16]),
    .wa3(MEM_WB_Rd),   
    .wd3(WBvalue),
    .rd1(RegReadData1),
    .rd2(RegReadData2),
    .in(RegAddr),.out(regout)
    );
    
    sign_extend st(IF_ID_instr[15:0],immediate);
    
    
    // branch detection
    wire [31:0] forwardRsData,forwardRsData_,forwardRtData,forwardRtData_,RegReadData1,RegReadData2;
    
    Mux3 muxRs(
    .in0(RegReadData1),
    .in1(EX_MEM_aluout),
    .in2(WBvalue),
    .signal(forwardSignal[3:2]),
    .out(forwardRsData)
    );
    
    Mux3 muxRt(
    .in0(RegReadData2),
    .in1(EX_MEM_aluout),
    .in2(WBvalue),
    .signal(forwardSignal[1:0]),
    .out(forwardRtData)
    );
    
    // to aviod reading non initialized register 
    assign forwardRtData_ = stall ? 1 : forwardRtData;
    assign forwardRsData_ = stall ? 0 : forwardRsData;
    assign branch = Beq ? ((forwardRtData_ == forwardRsData_) ? 1 : 0) : 0;
    
    
    // controller
    Controller c(IF_ID_instr,zero,alucontrol,
		PCsrc, RegWrite, MemWrite, MemRead,RegDst, ALUsrc, Mem2Reg, Beq, Jump, ShiftI, JumpV, Link);
    // control signals 
    
    // WB control: Mem2Reg_ID,RegWrite_ID                   2bit
    // MEM control: memwrite_ID                             1bit
    // EX control: ALUsrc_ID,RegDst_ID,alucontrol_ID        8bit
    Mux #(13) mux_control_signals(
    .in0({Mem2Reg,RegWrite,MemWrite,ALUsrc,RegDst,ShiftI,alucontrol}),
    .in1(0),
    .signal(stall | (IF_ID_instr == 0)),
    .out({Mem2Reg_ID,RegWrite_ID,MemWrite_ID,ALUsrc_ID,RegDst_ID,ShiftI_ID,alucontrol_ID})
    );
    
    
    // output instruction fields
    assign Rs = IF_ID_instr[25:21];
    assign Rt = IF_ID_instr[20:16];
    assign Rd = IF_ID_instr[15:11];
    assign shamt = IF_ID_instr[10:6];
endmodule
