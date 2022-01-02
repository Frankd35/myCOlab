module hilo (
    input clk,rst,
    input [31:0] regin,
    input [63:0] result,
    input [7:0] alucontrol,
    input result_ok,
    output [31:0] hilo_out
);
    reg [63:0] q = 0;

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