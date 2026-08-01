`timescale 1ns/1ps

module alucomp (
    input  signed [31:0] A,
    input  signed [31:0] B,
    output [31:0] Y
);

    wire signed [31:0] sub_result;
    wire ovf_pos, ovf_neg;
    wire overflow;
    wire less;

    // Reuse adder/subtractor (SUB mode)
    aluaddsub addsub_inst (
        .A(A),
        .B(B),
        .sub(1'b1),
        .Y(sub_result),
        .ovf_pos(ovf_pos),
        .ovf_neg(ovf_neg)
    );

    // Comparator logic (1ns delay)
    assign overflow = ovf_pos | ovf_neg;
    assign #1 less = sub_result[31] ^ overflow;

    assign #1 Y = less ? 32'b1 : 32'b0;

endmodule
