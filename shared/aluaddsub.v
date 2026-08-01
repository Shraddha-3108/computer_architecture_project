`timescale 1ns/1ps

module aluaddsub (
    input  [31:0] A,
    input  [31:0] B,
    input         sub,
    output [31:0] Y,
    output        ovf_pos,
    output        ovf_neg,
    output        carry_out_msb
);

    wire [31:0] B_mod;
    wire        cin;
    wire [32:0] sum_ext;

    wire carry_in_msb;

    assign B_mod = sub ? ~B : B;  // two's complement for subtraction
    assign cin   = sub;

    // 32-bit adder/subtractor (#3 delay)
    assign #3 sum_ext = {1'b0, A} + {1'b0, B_mod} + cin;

    // carry signals
    assign carry_out_msb = sum_ext[32];                        // <- fixed output
    assign carry_in_msb  = sum_ext[31] ^ A[31] ^ B_mod[31];

    // outputs
    assign #1 Y       = sum_ext[31:0];
    assign #1 ovf_pos = carry_in_msb & ~carry_out_msb;
    assign #1 ovf_neg = ~carry_in_msb & carry_out_msb;

endmodule
