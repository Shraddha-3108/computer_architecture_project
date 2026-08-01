`timescale 1ns/1ps

module dut (
    input  signed [31:0] A,
    input  signed [31:0] B,
    input                sub,
    output signed [31:0] Y,
    output               ovf_pos,
    output               ovf_neg
);

    aluaddsub u_addsub (
        .A(A),
        .B(B),
        .sub(sub),
        .Y(Y),
        .ovf_pos(ovf_pos),
        .ovf_neg(ovf_neg)
    );

endmodule
