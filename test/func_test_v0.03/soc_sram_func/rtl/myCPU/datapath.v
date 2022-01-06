`timescale 1ns / 1ps
`include "defines.vh"
`include "defines2.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/03 00:08:29
// Design Name: 
// Module Name: datapath
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


module datapath(
    input clk,rst,
    output EX_MEM_MemWrite,
    output [31:0] PCout,
    input [31:0] instr,
    output [31:0] MemAddr,
    output [31:0] writedata,
    input [31:0] readdata,
    output [3:0] bit_mask,
    output [31:0] debug_wb_pc,
    output [3:0] debug_wb_rf_wen,
    output [4:0] debug_wb_rf_wnum,
    output [31:0] debug_wb_rf_wdata
    );
    
    // debug wire
    wire [31:0] ID_EX_PC,EX_MEM_PC,MEM_WB_PC;
    wire [31:0] IF_ID_instr,ID_EX_instr,EX_MEM_instr,MEM_WB_instr;
    wire [39:0] ID_instr_,EX_instr_,MEM_instr_,WB_instr_;

    assign debug_wb_pc = MEM_WB_PC;
    assign debug_wb_rf_wen = MEM_WB_RegWrite ? 4'b1111 : 0;
    assign debug_wb_rf_wnum = MEM_WB_Rd;
    assign debug_wb_rf_wdata = WBvalue;

    instdec dec_ID(IF_ID_instr,ID_instr_);
    instdec dec_EX(ID_EX_instr,EX_instr_);
    instdec dec_MEM(EX_MEM_instr,MEM_instr_);
    instdec dec_WB(MEM_WB_instr,WB_instr_);

    // wire statement
    wire stall_IF,stall_ID,stall_EX,Beq,branch,jump,ID_EX_Beq,ID_EX_jump,branch_tacken,ALUoutEONE,EX_MEM_branch_tacken; // control signals
    wire [31:0] PCadd4,jumpAddr,branchAddr,ID_EX_jumpAddr,ID_EX_branchAddr,PCout;   // between IF ID
    wire [31:0] ALUout_EX,EX_MEM_ALUout,WBvalue,MEM_WB_writedata,jumpAddr_EX;  // forward datas
    wire [3:0] forwardSignalID,forwardSignalEX;
    wire Gforward;
    wire [4:0] MEM_WB_Rd;   // WB 
    wire MEM_WB_RegWrite;   // WB


    assign branch = ID_EX_Beq & ALUoutEONE;
    assign branch_tacken = branch | ID_EX_jump;

    // exception and interrupt
    wire SYSC_EXP,BREAK_EXP,RI_EXP,PC_EXP,OV_EXP,HW_INT,RA_EXP,WA_EXP,exp_handle;
    wire IF_ID_PC_EXP;                                                                      // IF_ID
    wire ID_EX_PC_EXP,ID_EX_SYSC_EXP,ID_EX_BREAK_EXP,ID_EX_RI_EXP;                          // ID_EX
    wire EX_MEM_PC_EXP,EX_MEM_SYSC_EXP,EX_MEM_BREAK_EXP,EX_MEM_RI_EXP,EX_MEM_OV_EXP;        // EX_MEM
    wire MTCP0,MFCP0,ID_EX_MTCP0,ID_EX_MFCP0;
    wire ERET,ID_EX_ERET;
    wire ID_EX_isdelayslot,EX_MEM_isdelayslot;
    wire [31:0] bad_addr,epc;

    // IF stage
    IF IFstage(
    .clk(clk),
    .rst(rst),
    .stall(stall_IF),
    .branch(branch),
    .exp_handle(exp_handle),.ERET(ERET),
    .jump(ID_EX_jump), 
    .PCadd4(PCadd4),                     
    .jumpAddr(jumpAddr_EX),
    .branchAddr(ID_EX_branchAddr),.epc(epc),
    .PCout(PCout),
    .PC_EXP(PC_EXP)
    );
    
    wire [31:0] IF_ID_PCout;

    // IF/ID registers
    flopflip #(0) IF_ID_EXP_register(
    .clk(clk),
    .rst(rst | exp_handle),
    .en(~stall_ID),
    .in(PC_EXP),
    .r(IF_ID_PC_EXP)
    );
    

    flopflip IF_ID_instr_register(
    .clk(clk),
    .rst(rst | exp_handle | ERET),
    .en(~stall_ID),
    .in(instr),
    .r(IF_ID_instr)
    );
    
    assign ERET = (instr == 32'b01000010000000000000000000011000);

    flopflip IF_ID_PCvalue_register(
    .clk(clk),
    .rst(rst),
    .en(~stall_ID),
    .in(PCout),
    .r(IF_ID_PCout)
    );

    wire Mem2Reg_ID,RegWrite_ID,MemWrite_ID,ALUsrc_ID,RegDst_ID;    // ID to ID_EX
    wire [7:0] alucontrol_ID;
    wire [31:0] RegReadData1,RegReadData2,immediate;
    wire [4:0] Rs,Rt,Rd,shamt;
    // ID stage
    ID IDstage(
    .clk(clk),.rst(rst),.stall(stall_ID),
    .MEM_WB_RegWrite(MEM_WB_RegWrite),
    .MEM_WB_Rd(MEM_WB_Rd),
    .forwardSignal(forwardSignalID),  // [3:2] for Reg[rs] and [1:0] for Reg[rt]
    .IF_ID_instr(IF_ID_instr),.IF_ID_PCout(IF_ID_PCout),.ShiftI_ID(ShiftI_ID),.JumpV(JumpV),
    .WBvalue(WBvalue),
    .EX_MEM_aluout(EX_MEM_ALUout),
    .EX_MEM_branch_tacken(EX_MEM_branch_tacken),
    // output
    .Mem2Reg_ID(Mem2Reg_ID),.RegWrite_ID(RegWrite_ID),.MemWrite_ID(MemWrite_ID),.ALUsrc_ID(ALUsrc_ID),.RegDst_ID(RegDst_ID),
    .alucontrol_ID(alucontrol_ID),
    .branch(),.Jump(jump),.Beq(Beq),
    .RegReadData1(RegReadData1),.RegReadData2(RegReadData2),.immediate(immediate),
    .PCadd4(PCadd4),    // actual is PC + 8, which PC refers to ID stage coresponding instruction
    .jumpAddr(jumpAddr),.branchAddr(branchAddr),
    .Rs(Rs),.Rt(Rt),.Rd(Rd),.shamt(shamt),
    .SYSC_EXP(SYSC_EXP),.BREAK_EXP(BREAK_EXP),.RI_EXP(RI_EXP),
    .MFCP0(MFCP0),.MTCP0(MTCP0)
    );    
    
    wire ID_EX_Mem2Reg,ID_EX_RegWrite,ID_EX_MemWrite,ID_EX_ALUsrc,ID_EX_RegDst;
    wire [7:0] ID_EX_alucontrol;
    wire [31:0] ID_EX_RegReadData1,ID_EX_RegReadData2,ID_EX_immediate,ID_EX_PCadd8;
    wire [4:0] ID_EX_Rs,ID_EX_Rt,ID_EX_Rd,ID_EX_shamt;
    
    // ID/EX register
    flopflip #(3)ID_EX_EXP_resgister(
    .clk(clk),
    .rst(rst | exp_handle), 
    .en(~stall_EX),
    .in({IF_ID_PC_EXP,SYSC_EXP,BREAK_EXP,RI_EXP}),
    .r({ID_EX_PC_EXP,ID_EX_SYSC_EXP,ID_EX_BREAK_EXP,ID_EX_RI_EXP})
    );
    
    flopflip #(0)ID_EX_isdelayslot_resgister(
    .clk(clk),
    .rst(rst | exp_handle), 
    .en(~stall_EX),
    .in(ID_EX_jump | ID_EX_Beq),
    .r(ID_EX_isdelayslot)
    );

    flopflip #(18)ID_EX_Controlsignal_resgister(
    .clk(clk),
    .rst(rst | exp_handle), 
    .en(~stall_EX),
    .in({Mem2Reg_ID,RegWrite_ID,MemWrite_ID,ALUsrc_ID,RegDst_ID,
        ShiftI_ID,alucontrol_ID,jump,Beq,JumpV,MTCP0,MFCP0}),
    .r({ID_EX_Mem2Reg,ID_EX_RegWrite,ID_EX_MemWrite,ID_EX_ALUsrc,ID_EX_RegDst,
        ID_EX_ShiftI,ID_EX_alucontrol,ID_EX_jump,ID_EX_Beq,ID_EX_JumpV,
        ID_EX_MTCP0,ID_EX_MFCP0})
    );
    
    flopflip ID_EX_PCvalue_register(
    .clk(clk),
    .rst(rst),
    .en(~stall_EX),
    .in(IF_ID_PCout),
    .r(ID_EX_PC)
    );

    flopflip ID_EX_inst_register(
    .clk(clk),
    .rst(rst),
    .en(~stall_EX),
    .in(IF_ID_instr),
    .r(ID_EX_instr)
    );
    
    flopflip ID_EX_ReadData1_resgister(
    .clk(clk),
    .rst(rst),
    .en(~stall_EX),
    .in(RegReadData1),
    .r(ID_EX_RegReadData1)
    );
    
    flopflip ID_EX_ReadData2_resgister(
    .clk(clk),
    .rst(rst),
    .en(~stall_EX),
    .in(RegReadData2),
    .r(ID_EX_RegReadData2)
    );
    
    flopflip ID_EX_immediate_resgister(
    .clk(clk),
    .rst(rst),
    .en(~stall_EX),
    .in(immediate),
    .r(ID_EX_immediate)
    );

    flopflip ID_EX_jumpAddr_resgister(
    .clk(clk),
    .rst(rst),
    .en(~stall_EX),
    .in(jumpAddr),
    .r(ID_EX_jumpAddr)
    );
    
    flopflip ID_EX_branchAddr_resgister(
    .clk(clk),
    .rst(rst),
    .en(~stall_EX),
    .in(branchAddr),
    .r(ID_EX_branchAddr)
    );
    
    flopflip ID_EX_PCadd4(
    .clk(clk),
    .rst(rst),
    .en(~stall_EX),
    .in(PCadd4+4),
    .r(ID_EX_PCadd8)
    );
    
    flopflip #(19) ID_EX_instructionfield_resgister(
    .clk(clk),
    .rst(rst),
    .en(~stall_EX),
    .in({Rs,Rt,Rd,shamt}),
    .r({ID_EX_Rs,ID_EX_Rt,ID_EX_Rd,ID_EX_shamt})
    );
    
    
    wire [31:0] ALUout_EX,forwardRtData_EX;     // EX to EX_MEM
    wire [4:0] Rd_EX;
    // EX stage
    EX  EXstage(
    //input
    clk,rst,
    ID_EX_ALUsrc,
    ID_EX_RegDst,ID_EX_ShiftI,ID_EX_JumpV,
    ID_EX_alucontrol,
    forwardSignalEX,  // [3:2] for Reg[rs] and [1:0] for Reg[rt]
    ID_EX_RegReadData1,ID_EX_RegReadData2,ID_EX_immediate,
    EX_MEM_ALUout,
    WBvalue,
    ID_EX_PCadd8,ID_EX_jumpAddr,
    ID_EX_Rt,ID_EX_Rd,ID_EX_shamt,
    // output
    overflow,
    ALUout_EX,
    forwardRtData_EX,jumpAddr_EX,
    Rd_EX,
    result_notok,ALUoutEONE
    );
    
    wire EX_MEM_Mem2Reg,EX_MEM_RegWrite,EX_MEM_MemWrite;
    wire [31:0] EX_MEM_forwardRtData;
    wire [7:0] EX_MEM_alucontrol;
    wire [4:0] EX_MEM_Rd;
    
    // EX/MEM register
    flopflip #(4) EX_MEM_EXP_register(
    .clk(clk),
    .rst(rst | exp_handle),
    .en(~stall_EX),
    .in({ID_EX_PC_EXP,ID_EX_SYSC_EXP,ID_EX_BREAK_EXP,ID_EX_RI_EXP,overflow}),
    .r({EX_MEM_PC_EXP,EX_MEM_SYSC_EXP,EX_MEM_BREAK_EXP,EX_MEM_RI_EXP,EX_MEM_OV_EXP})
    );
    
    flopflip #(0) EX_MEM_isdelayslot_register(
    .clk(clk),
    .rst(rst | exp_handle),
    .en(1),
    .in(ID_EX_isdelayslot),
    .r(EX_MEM_isdelayslot)
    );

    flopflip #(2) EX_MEM_controlsignal_register(
    .clk(clk),
    .rst(rst | exp_handle),
    .en(1),
    .in({ID_EX_Mem2Reg,ID_EX_RegWrite,ID_EX_MemWrite}),
    .r({EX_MEM_Mem2Reg,EX_MEM_RegWrite,EX_MEM_MemWrite})
    );
    
    // if delay slot stall at EX stage, branch tacken signal need special stall
    flopflip #(0) EX_MEM_branch_tacken_control_register(
    .clk(clk),
    .rst(rst | exp_handle),
    .en(~stall_EX),
    .in(branch_tacken),
    .r(EX_MEM_branch_tacken)
    );
 
    flopflip EX_MEM_PCvalue_register(
    .clk(clk),
    .rst(rst),
    .en(1),
    .in(ID_EX_PC),
    .r(EX_MEM_PC)
    );
    
    flopflip EX_MEM_instr_register(
    .clk(clk),
    .rst(rst),
    .en(1),
    .in(ID_EX_instr),
    .r(EX_MEM_instr)
    );

    wire [31:0] cp0out, ALUout_mux;
    assign ALUout_mux = ID_EX_MFCP0 ? cp0out : ALUout_EX;
    flopflip EX_MEM_ALUout_register(
    .clk(clk),
    .rst(rst),
    .en(1),
    .in(ALUout_mux),
    .r(EX_MEM_ALUout)
    );
    
    flopflip EX_MEM_forwardRtData_register(
    .clk(clk),
    .rst(rst),
    .en(1),
    .in(forwardRtData_EX),
    .r(EX_MEM_forwardRtData)
    );
    
    flopflip #(4) EX_MEM_Rd_register(
    .clk(clk),
    .rst(rst),
    .en(1),
    .in(Rd_EX),
    .r(EX_MEM_Rd)
    );
    
    flopflip #(7) EX_MEM_alucontrol_register(
    .clk(clk),
    .rst(rst | exp_handle),
    .en(1),
    .in(ID_EX_alucontrol),
    .r(EX_MEM_alucontrol)
    );

    wire [31:0] readdata_MEM,readdata_mask;     // readdata_MEM unused
    // MEM stage
    assign MemAddr = EX_MEM_ALUout;
    assign writedata = (EX_MEM_alucontrol == `EXE_SW_OP) ?  EX_MEM_forwardRtData :
                       (EX_MEM_alucontrol == `EXE_SH_OP) ? {2{EX_MEM_forwardRtData[15:0]}} : 
                       (EX_MEM_alucontrol == `EXE_SB_OP) ? {4{EX_MEM_forwardRtData[7:0]}} :
                       32'b0000;
    
    wire [1:0] bit_off;

    assign bit_off = MemAddr[1:0];
    assign bit_mask = WA_EXP ? 4'b000 :                                 // write address exception should not write
                      (EX_MEM_alucontrol == `EXE_SW_OP) ? 4'b1111 :
                      (EX_MEM_alucontrol == `EXE_SH_OP) ? (bit_off[1] ? 4'b1100 : 4'b0011) :
                      (EX_MEM_alucontrol == `EXE_SB_OP) ?
                      (
                          (bit_off == 2'b11) ? 4'b1000 :  
                          (bit_off == 2'b10) ? 4'b0100 :
                          (bit_off == 2'b01) ? 4'b0010 :
                          (bit_off == 2'b00) ? 4'b0001 : 4'b0000
                      ) : 4'b0000;                      // lw & lh & lb


    assign readdata_mask = (EX_MEM_alucontrol == `EXE_LW_OP) ? readdata : 
                           (EX_MEM_alucontrol == `EXE_LH_OP) ? ( 
                               ~bit_off[1] ? {{16{readdata[15]}},readdata[15:0]} : {{16{readdata[31]}},readdata[31:16]}
                           ) :
                           (EX_MEM_alucontrol == `EXE_LHU_OP) ? ( 
                               ~bit_off[1] ? {16'b0,readdata[15:0]} : {16'b0,readdata[31:16]}
                           ) :
                           (EX_MEM_alucontrol == `EXE_LB_OP) ? (
                               (bit_off == 2'b00) ? {{24{readdata[7]}},readdata[7:0]} :
                               (bit_off == 2'b01) ? {{24{readdata[15]}},readdata[15:8]} :
                               (bit_off == 2'b10) ? {{24{readdata[23]}},readdata[23:16]} :
                               (bit_off == 2'b11) ? {{24{readdata[31]}},readdata[31:24]} : 0
                           ) :
                           (EX_MEM_alucontrol == `EXE_LBU_OP) ? (
                               (bit_off == 2'b00) ? {24'b0,readdata[7:0]} :
                               (bit_off == 2'b01) ? {24'b0,readdata[15:8]} :
                               (bit_off == 2'b10) ? {24'b0,readdata[23:16]} :
                               (bit_off == 2'b11) ? {24'b0,readdata[31:24]} : 0
                           ) : 0;

    assign RA_EXP = (EX_MEM_alucontrol == `EXE_LH_OP) | (EX_MEM_alucontrol == `EXE_LHU_OP) ? (
                    bit_off[0] == 1 ? 1 : 0
                    ) :
                    (EX_MEM_alucontrol == `EXE_LW_OP) ? (bit_off == 2'b00 ? 0 : 1) :
                    0;
                    
    assign WA_EXP = (EX_MEM_alucontrol == `EXE_SW_OP) ? (bit_off == 2'b00 ? 0 : 1) :
                    (EX_MEM_alucontrol == `EXE_SH_OP) ? (bit_off[0] == 1 ? 1 : 0) :
                    0;

    // exception & iterrupt handling at MEM stage
    wire [31:0] cause,status,exp_code;
    
    // detect posedge of software interrput signal
    wire old_sftw_itrpt, new_sftw_itrpt,SW_INT;
    assign SW_INT = (new_sftw_itrpt == 1 & old_sftw_itrpt == 0);
    assign new_sftw_itrpt = |(status[9:8] & cause[9:8]) & status[1] == 0;
    flopflip #(0) software_interrput_register(
    .clk(clk),
    .rst(rst),
    .en(1),
    .in(new_sftw_itrpt),      
    .r(old_sftw_itrpt)           // older 1 CC
    );

    
    assign exp_handle = EX_MEM_PC_EXP | EX_MEM_SYSC_EXP | EX_MEM_BREAK_EXP | EX_MEM_RI_EXP | EX_MEM_OV_EXP | 
                        RA_EXP | WA_EXP | SW_INT;
    
    assign exp_code = ERET ? 32'h0000000e :                                     // eret has best priority
                      SW_INT ? 32'h00000000 :
                      EX_MEM_PC_EXP | RA_EXP ? 32'h00000004 :
                      EX_MEM_RI_EXP ? 32'h0000000a :
                      EX_MEM_OV_EXP ? 32'h0000000c :
                      (EX_MEM_BREAK_EXP & status[1] == 0) ? 32'h00000009 :
                      (EX_MEM_SYSC_EXP & status[1] == 0) ? 32'h00000008 :
                      WA_EXP ? 32'h00000005 :
                      32'hffff_ffff;    // default, do not thing here

    assign bad_addr =  EX_MEM_PC_EXP ? EX_MEM_PC :
                       RA_EXP | WA_EXP ? MemAddr :
                       0;

    cp0_reg cp0(
	.clk(clk),
    .rst(rst),.we_i(ID_EX_MTCP0),
    .waddr_i(ID_EX_Rd),
    .raddr_i(ID_EX_Rt),
    .data_i(forwardRtData_EX),
    .int_i(6'b000000),
    .excepttype_i(exp_code),
	.current_inst_addr_i(EX_MEM_PC),
    .is_in_delayslot_i(EX_MEM_isdelayslot),
	.bad_addr_i(bad_addr),
    .data_o(cp0out),
    .epc_o(epc),
    
    // do not implement this function
    .count_o(),.compare_o(),.status_o(status),.cause_o(cause),.config_o(),.prid_o(),.badvaddr()
    );




    wire MEM_WB_Mem2Reg,MEM_WB_MemWrite;
    wire [31:0] MEM_WB_ALUout,MEM_WB_readdata;
    // MEM/WB register
    flopflip #(2) MEM_WB_controlsignal_register(
    .clk(clk),
    .rst(rst | exp_handle),
    .en(1),
    .in({EX_MEM_Mem2Reg,EX_MEM_RegWrite,EX_MEM_MemWrite}),
    .r({MEM_WB_Mem2Reg,MEM_WB_RegWrite,MEM_WB_MemWrite})
    );
    
    flopflip MEM_WB_PCvalue_register(
    .clk(clk),
    .rst(rst),
    .en(1),
    .in(EX_MEM_PC),
    .r(MEM_WB_PC)
    );
    
    flopflip MEM_WB_instr_register(
    .clk(clk),
    .rst(rst),
    .en(1),
    .in(EX_MEM_instr),
    .r(MEM_WB_instr)
    );
    
    flopflip #(4) MEM_WB_Rd_register(
    .clk(clk),
    .rst(rst),
    .en(1),
    .in(EX_MEM_Rd),
    .r(MEM_WB_Rd)
    );
    
    flopflip MEM_WB_ALUout_register(
    .clk(clk),
    .rst(rst),
    .en(1),
    .in(EX_MEM_ALUout),
    .r(MEM_WB_ALUout)
    );
    
    flopflip MEM_WB_readdata_register(
    .clk(clk),
    .rst(rst),
    .en(1),
    .in(readdata_mask),
    .r(MEM_WB_readdata)
    );
    
    flopflip MEM_WB_writedata_register(
    .clk(clk),
    .rst(rst),
    .en(1),
    .in(EX_MEM_forwardRtData),
    .r(MEM_WB_writedata)
    );

    // WB stage    
    
    Mux Mux_WBvalue(
    .in0(MEM_WB_ALUout),
    .in1(MEM_WB_readdata),
    .signal(MEM_WB_Mem2Reg),
    .out(WBvalue)
    );
    
    //forward unit
    forwardunit forwardunitID(
    EX_MEM_RegWrite,
    EX_MEM_Mem2Reg,
    MEM_WB_RegWrite,
    EX_MEM_Rd, 
    MEM_WB_Rd,
    IF_ID_instr[25:21],
    IF_ID_instr[20:16],
    forwardSignalID[3:2],forwardSignalID[1:0]
    );
    
    forwardunit forwardunitEX(
    EX_MEM_RegWrite,
    EX_MEM_Mem2Reg,
    MEM_WB_RegWrite,
    EX_MEM_Rd, 
    MEM_WB_Rd,
    ID_EX_Rs,
    ID_EX_Rt,
    forwardSignalEX[3:2],forwardSignalEX[1:0]
    );
    
    // generalforward gf(               lw+sw
    // MEM_WB_MemWrite,EX_MEM_Mem2Reg,
    // EX_MEM_ALUout,MEM_WB_ALUout,
    // Gforward
    // );
    
    hazard detaction(
    Beq,jump,result_notok,
    ID_EX_RegWrite,
    EX_MEM_Mem2Reg,
    ID_EX_Mem2Reg,
    IF_ID_instr[25:21],
    IF_ID_instr[20:16],
    Rd_EX,
    EX_MEM_Rd,
    stall_IF, stall_ID, stall_EX
    );
endmodule
