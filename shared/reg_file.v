`timescale 1ns/1ps
module reg_file (
    input clk,
    input reset,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] wd,
    input we,
    output [31:0] rdata1,
    output [31:0] rdata2
);

    wire [31:0] reg_outs [0:31];

    wire [31:0] write_selects;

    decoder5to32 write_decoder (
        .rd(rd),
        .reg_write_en(we),
        .dec_out(write_selects)
    );

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : reg_loop

            if (i == 0) begin : x0_rule
                // x0 hard-wired to zero
                reg32 rx (
                    .clk(clk),
                    .reset(1'b1),   // always reset
                    .we(1'b0),      // never writable
                    .d(32'b0),
                    .q(reg_outs[i])
                );
            end
            else begin : normal_regs
                reg32 rx (
                    .clk(clk),
                    .reset(reset),
                    .we(write_selects[i]),
                    .d(wd),
                    .q(reg_outs[i])
                );
            end

        end
    endgenerate

    assign #1 rdata1 = reg_outs[rs1];
    assign #1 rdata2 = reg_outs[rs2];

endmodule