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
    input EX_MEM_branch_tacken,
    output Mem2Reg_ID,RegWrite_ID,MemWrite_ID,ALUsrc_ID,RegDst_ID,ShiftI_ID,JumpV,
    output [7:0] alucontrol_ID,
    output branch,Beq,Jump,
    output [31:0] RegReadData1,RegReadData2,immediate,PCadd4,jumpAddr,branchAddr,
    output [4:0] Rs,Rt,Rd,shamt,
    output SYSC_EXP,BREAK_EXP,RI_EXP,MFCP0,MTCP0
    );    
    wire Mem2Reg,RegWrite,MemWrite,ALUsrc,RegDst,Beq,Jump,ShiftI,JumpV,Link;   // control signals
    wire [7:0] alucontrol;      // control signals
    
    
    // combinationl logicals for branchAddress and jumpAddress
    
    wire [31:0] PCadd4,immediate,offeset;

    
    Adder pcadd4(IF_ID_PCout,4,PCadd4);
    // sl2 shiftleft({6'b000000,},jumpAddr);
    assign jumpAddr = {PCadd4[31:28],IF_ID_instr[25:0],2'b00};
    sl2 shiftleft2(immediate,offeset);
    Adder branchAddrAdder(PCadd4,offeset,branchAddr);
    
    
    // regfile 
    regfile Reg(
    .clk(clk),.rst(rst),
    .we3(MEM_WB_RegWrite),    // RegWrite signal
    .ra1(IF_ID_instr[25:21]),
    .ra2(IF_ID_instr[20:16]),
    .wa3(MEM_WB_Rd),   
    .wd3(WBvalue),
    .rd1(RegReadData1),
    .rd2(RegReadData2)
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
    wire SYSC_EXP_,BREAK_EXP_,RI_EXP_,MFCP0_,MTCP0_,Beq_,jump_;
    Controller c(IF_ID_instr,zero,alucontrol,
		PCsrc, RegWrite, MemWrite, MemRead,RegDst, ALUsrc, Mem2Reg, Beq_, jump_, ShiftI, JumpV, Link,
    SYSC_EXP_,BREAK_EXP_,RI_EXP_,MFCP0_,MTCP0_
    );
    
    // control signals 
    // WB control: Mem2Reg_ID,RegWrite_ID                   2bit
    // MEM control: memwrite_ID                             1bit
    // EX control: ALUsrc_ID,RegDst_ID,ShiftI_ID,alucontrol_ID        11bit
    // flow control: jump,beq ---> 记得重命�?                 2bit
    // EXP decode 3bit
    // mf/mt cp0 2bit
    Mux #(20) mux_control_signals(
    .in0({Mem2Reg,RegWrite,MemWrite,ALUsrc,RegDst,ShiftI,alucontrol,jump_,Beq_,
          SYSC_EXP_,BREAK_EXP_,RI_EXP_,MFCP0_,MTCP0_}),
    .in1(0),
    // stall & nop instruction & IM[PC+8] which IM[PC] is a taken branck/jump
    // should set their control signals to zero
    .signal(stall | (IF_ID_instr == 0) | EX_MEM_branch_tacken),
    .out({Mem2Reg_ID,RegWrite_ID,MemWrite_ID,ALUsrc_ID,RegDst_ID,ShiftI_ID,alucontrol_ID,Jump,Beq,
          SYSC_EXP,BREAK_EXP,RI_EXP,MFCP0,MTCP0})
    );
    
    
    // output instruction fields
    assign Rs = IF_ID_instr[25:21];
    assign Rt = MFCP0 ? IF_ID_instr[15:11] : IF_ID_instr[20:16];
    assign Rd = ((alucontrol == `EXE_BGEZAL_OP) | (alucontrol == `EXE_BLTZAL_OP) | 
                 (alucontrol == `EXE_JAL_OP)) ? 5'b11111 :
                 MFCP0 ? IF_ID_instr[20:16] : IF_ID_instr[15:11];
    assign shamt = IF_ID_instr[10:6];
endmodule
