`timescale 1ns / 1ps
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
    output overflow,zero,
    output EX_MEM_MemWrite,
    output [31:0] PCout,
    input [31:0] instr,
    output [31:0] MemAddr,
    output [31:0] writedata,
    input [31:0] readdata

    ,input [31:0] RegAddr,output [31:0] regout 

    );
    
    // wire statement
    wire stall,Beq,branch,jump; // control signals
    wire [31:0] PCadd4,jumpAddr,branchAddr,PCout,IF_ID_PCout_;   // between IF ID
    wire [31:0] EX_MEM_ALUout,WBvalue,MEM_WB_writedata;  // forward datas
    wire [3:0] forwardSignalID,forwardSignalEX;
    wire Gforward;
    wire [4:0] MEM_WB_Rd;   // WB 
    wire MEM_WB_RegWrite;   // WB
    // IF stage
    IF IFstage(
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .branch(branch),
    .jump(jump), 
    .PCadd4(PCadd4),
    .jumpAddr(jumpAddr),
    .branchAddr(branchAddr),
    .PCout(PCout)
    );
    
    wire [31:0] IF_ID_instr,IF_ID_PCout;
    // IF/ID registers
    flopflip IF_ID_instr_register(
    .clk(clk),
    .rst(rst),
    .en(~stall),
    .in(instr),
    .r(IF_ID_instr)
    );
    
    flopflip IF_ID_PCvalue_register(
    .clk(clk),
    .rst(rst),
    .en(~stall),
    .in(PCout),
    .r(IF_ID_PCout)
    );
    
    flopflip IF_ID_PCvalue_register_(
    .clk(~clk),
    .rst(rst),
    .en(~stall),
    .in(PCout),
    .r(IF_ID_PCout_)
    );

    wire Mem2Reg_ID,RegWrite_ID,MemWrite_ID,ALUsrc_ID,RegDst_ID;    // ID to ID_EX
    wire [2:0] alucontrol_ID;
    wire [31:0] RegReadData1,RegReadData2,immediate;
    wire [4:0] Rs,Rt,Rd;
    // ID stage
    ID IDstage(
    .clk(clk),.rst(rst),.stall(stall),
    .MEM_WB_RegWrite(MEM_WB_RegWrite),
    .MEM_WB_Rd(MEM_WB_Rd),
    .forwardSignal(forwardSignalID),  // [3:2] for Reg[rs] and [1:0] for Reg[rt]
    .IF_ID_instr(IF_ID_instr),.IF_ID_PCout(IF_ID_PCout),.IF_ID_PCout_(IF_ID_PCout_),
    .WBvalue(WBvalue),
    .EX_MEM_aluout(EX_MEM_ALUout),
    // output
    .Mem2Reg_ID(Mem2Reg_ID),.RegWrite_ID(RegWrite_ID),.MemWrite_ID(MemWrite_ID),.ALUsrc_ID(ALUsrc_ID),.RegDst_ID(RegDst_ID),
    .alucontrol_ID(alucontrol_ID),
    .branch(branch),.Jump(jump),.Beq(Beq),
    .RegReadData1(RegReadData1),.RegReadData2(RegReadData2),.immediate(immediate),
    .PCadd4(PCadd4),.jumpAddr(jumpAddr),.branchAddr(branchAddr),
    .Rs(Rs),.Rt(Rt),.Rd(Rd)
    ,.RegAddr(RegAddr),.regout(regout) 
    );    
    
    wire ID_EX_Mem2Reg,ID_EX_RegWrite,ID_EX_MemWrite,ID_EX_ALUsrc,ID_EX_RegDst;
    wire [2:0] ID_EX_alucontrol;
    wire [31:0] ID_EX_RegReadData1,ID_EX_RegReadData2,ID_EX_immediate;
    wire [4:0] ID_EX_Rs,ID_EX_Rt,ID_EX_Rd;
    // ID/EX register
    flopflip #(7)ID_EX_Controlsignal_resgister(
    .clk(clk),
    .rst(rst),
    .en(1),
    .in({Mem2Reg_ID,RegWrite_ID,MemWrite_ID,ALUsrc_ID,RegDst_ID,alucontrol_ID}),
    .r({ID_EX_Mem2Reg,ID_EX_RegWrite,ID_EX_MemWrite,ID_EX_ALUsrc,ID_EX_RegDst,ID_EX_alucontrol})
    );
    
    flopflip ID_EX_ReadData1_resgister(
    .clk(clk),
    .rst(rst),
    .en(1),
    .in(RegReadData1),
    .r(ID_EX_RegReadData1)
    );
    
    flopflip ID_EX_ReadData2_resgister(
    .clk(clk),
    .rst(rst),
    .en(1),
    .in(RegReadData2),
    .r(ID_EX_RegReadData2)
    );
    
    flopflip ID_EX_immediate_resgister(
    .clk(clk),
    .rst(rst),
    .en(1),
    .in(immediate),
    .r(ID_EX_immediate)
    );
    
    flopflip #(14) ID_EX_instructionfield_resgister(
    .clk(clk),
    .rst(rst),
    .en(1),
    .in({Rs,Rt,Rd}),
    .r({ID_EX_Rs,ID_EX_Rt,ID_EX_Rd})
    );
    
    
    wire [31:0] ALUout_EX,forwardRtData_EX;     // EX to EX_MWM
    wire [4:0] Rd_EX;
    // EX stage
    EX  EXstage(
    ID_EX_ALUsrc,
    ID_EX_RegDst,
    ID_EX_alucontrol,
    forwardSignalEX,  // [3:2] for Reg[rs] and [1:0] for Reg[rt]
    ID_EX_RegReadData1,ID_EX_RegReadData2,ID_EX_immediate,
    EX_MEM_ALUout,
    WBvalue,
    ID_EX_Rt,ID_EX_Rd,
    ALUout_EX,
    forwardRtData_EX,
    Rd_EX
    ,ALUin
    );
    
    wire EX_MEM_Mem2Reg,EX_MEM_RegWrite,EX_MEM_MemWrite;
    wire [31:0] EX_MEM_forwardRtData;
    wire [4:0] EX_MEM_Rd;
    // EX/MEM register
    flopflip #(2) EX_MEM_controlsignal_register(
    .clk(clk),
    .rst(rst),
    .en(1),
    .in({ID_EX_Mem2Reg,ID_EX_RegWrite,ID_EX_MemWrite}),
    .r({EX_MEM_Mem2Reg,EX_MEM_RegWrite,EX_MEM_MemWrite})
    );
    
    flopflip EX_MEM_ALUout_register(
    .clk(clk),
    .rst(rst),
    .en(1),
    .in(ALUout_EX),
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
    
    wire [31:0] readdata_MEM;
    // MEM stage
    assign MemAddr = EX_MEM_ALUout;
    assign writedata = EX_MEM_forwardRtData;
        
    /*Mux Mux_MEM_WB_readdata(
    .in0(readdate),
    .in1(MEM_WB_writedata),
    .signal(Gforward),
    .out(readdata_MEM)
    );*/
    
    wire MEM_WB_Mem2Reg,MEM_WB_MemWrite;
    wire [31:0] MEM_WB_ALUout,MEM_WB_readdata;
    
    // MEM/WB register
    flopflip #(2) MEM_WB_controlsignal_register(
    .clk(clk),
    .rst(rst),
    .en(1),
    .in({EX_MEM_Mem2Reg,EX_MEM_RegWrite,EX_MEM_MemWrite}),
    .r({MEM_WB_Mem2Reg,MEM_WB_RegWrite,MEM_WB_MemWrite})
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
    .in(readdata),
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
    
    generalforward gf(
    MEM_WB_MemWrite,EX_MEM_Mem2Reg,
    EX_MEM_ALUout,MEM_WB_ALUout,
    Gforward
    );
    
    hazard detaction(
    Beq,jump,
    ID_EX_RegWrite,
    EX_MEM_Mem2Reg,
    ID_EX_Mem2Reg,
    IF_ID_instr[25:21],
    IF_ID_instr[20:16],
    Rd_EX,
    EX_MEM_Rd,
    stall
    );
endmodule
