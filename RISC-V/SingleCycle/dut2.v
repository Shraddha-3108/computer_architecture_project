`timescale 1ns/1ps

module dut (
    input  [31:0] A,
    input  [31:0] B,
    input         dir,   // 0 = SLL, 1 = SRL
    output [31:0] Y
);
    alushift shifter_inst (
        .A(A),
        .B(B),
        .dir(dir),
        .Y(Y)
    );

endmodule
