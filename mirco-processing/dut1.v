`timescale 1ns/1ps
module dut (
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

reg_file RF (
    .clk(clk),
    .reset(reset),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .wd(wd),
    .we(we),
    .rdata1(rdata1),
    .rdata2(rdata2)
);

endmodule