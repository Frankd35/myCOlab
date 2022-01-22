module mycpu_top(
    input clk,resetn,
    input [5:0] int,

    //cpu inst sram
    output inst_sram_en,
    output [3:0] inst_sram_wen,
    output [31:0] inst_sram_addr,inst_sram_wdata,
    input [31:0] inst_sram_rdata,


    output data_sram_en,
    output [3:0] data_sram_wen,
    output [31:0] data_sram_addr,
    output [31:0] data_sram_wdata,
    input [31:0] data_sram_rdata,

    //debug
    output [31:0] debug_wb_pc,
    output [3:0] debug_wb_rf_wen,
    output [4:0] debug_wb_rf_wnum,
    output [31:0] debug_wb_rf_wdata
);

    // unused ports
    assign inst_sram_en = 1;
    assign inst_sram_wen = 4'b0000;
    assign inst_sram_wdata = 0;


    wire [31:0] pc,aluout;

    mips mymips(
    ~clk,~resetn,
    pc,
    inst_sram_rdata,
	data_sram_en,
	aluout,          // aluout
    data_sram_wdata,
	data_sram_rdata,
	data_sram_wen,
    // debug signal here
    debug_wb_pc,
    debug_wb_rf_wen,
    debug_wb_rf_wnum,
    debug_wb_rf_wdata
    );
    
    mmu mmu(
    .inst_vaddr(pc),
    .inst_paddr(inst_sram_addr),
    .data_vaddr(aluout),
    .data_paddr(data_sram_addr)
    // output wire no_dcache    //ÊÇ·ñ¾­¹ıd cache
    );
endmodule