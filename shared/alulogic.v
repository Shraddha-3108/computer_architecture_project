`timescale 1ns/1ps

module alulogic (
    input  [31:0] A,
    input  [31:0] B,
    input         op,   // 0 = AND, 1 = OR
    output [31:0] Y
);

    wire [31:0] and_out;
    wire [31:0] or_out;

    // 1ns logic delay
    assign #1 and_out = A & B;
    assign #1 or_out  = A | B;

    // 1ns mux delay
    assign #1 Y = op ? or_out : and_out;

endmodule
