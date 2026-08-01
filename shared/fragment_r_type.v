`timescale 1ns/1ps
module fragment_r_type (
    input clk,
    input reset,
    input reg_write,
    input [31:0] inst
);

    wire [4:0] rs1    = inst[19:15];
    wire [4:0] rs2    = inst[24:20];
    wire [4:0] rd     = inst[11:7];
    wire [2:0] funct3 = inst[14:12];
    wire [6:0] funct7 = inst[31:25];

    wire [31:0] rdata1;
    wire [31:0] rdata2;
    wire [31:0] alu_result;
    wire [2:0]  alu_control;
    wire zero_flag;

    reg_file rf (
        .clk(clk),
        .reset(reset),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(alu_result),
        .we(reg_write),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    alu_ctrl ctrl (
        .funct3(funct3),
        .funct7(funct7),
        .alu_ctrl(alu_control)
    );

    rv32ialu alu (
        .A(rdata1),
        .B(rdata2),
        .alu_ctrl(alu_control),
        .Y(alu_result),
        .zero(zero_flag)
    );

endmodule