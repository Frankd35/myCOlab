module hilo (
    input clk,rst,
    input [31:0] regin,
    input [63:0] result,
    input [7:0] alucontrol,
    input result_ok,
    output [31:0] hilo_out
);
    reg [63:0] pos_q = 0, neg_q = 0;
    reg [63:0] q = 0;

    // this fucking thing need be sensitive to both posedge & negedge of clk
    // for posedge, the new MU/DU result can be written into hile register
    // for negedge, the mthi/mtlo instruction will write data to hilo


    // 不知道行不行
    // always @(posedge clk) begin
    //     if (rst) pos_q <= 0;
    //     else 
    //         pos_q <= result;
    // end

    // always @(negedge clk) begin
    //     if (rst) neg_q <= 0;
    //     else 
    //         neg_q <= result;
    // end

    // always begin
    //     q = rst ? 0 : (clk ? 
    //                         (result_ok ? pos_q : q) :
    //                         (
    //                             (alucontrol == `EXE_MTHI_OP) ? {neg_q[63:32],q[31:0]} :
    //                             (alucontrol == `EXE_MTLO_OP) ? {q[63:32],neg_q[31:0]} : q
    //                         )
    //                     );
    // end
    

    // hilo actually works on MEM stage
    always @(posedge clk) begin            
        if (rst)
            q <= 0;
        else if (result_ok) begin                 
            q <= result;
        end
        else begin                             
            case (alucontrol)
                `EXE_MTHI_OP:   q[63:32] <= regin; 
                `EXE_MTLO_OP:   q[31:0] <= regin; 
                default: ;
            endcase
        end
    end

    assign hilo_out = (alucontrol == `EXE_MFHI_OP) ? q[63:32] :
                      (alucontrol == `EXE_MFLO_OP) ? q[31:0] :
                      0;

endmodule