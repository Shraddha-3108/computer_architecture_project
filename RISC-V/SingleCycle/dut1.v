`timescale 1ns/1ps

module dut (
    input  [31:0] A,
    input  [31:0] B,
    input         op,
    output [31:0] Y
);

    alulogic u_logic (
        .A(A),
        .B(B),
        .op(op),
        .Y(Y)
    );

endmodule
