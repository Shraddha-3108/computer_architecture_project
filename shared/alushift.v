`timescale 1ns/1ps

module alushift (
    input  [31:0] A,
    input  [31:0] B,
    input         dir,   // 0 = SLL, 1 = SRL
    output [31:0] Y
);

    wire [4:0] shamt;
    assign shamt = B[4:0];

    // Logical shifts only
    assign #2 Y = (dir == 1'b0) ? (A << shamt) : (A >> shamt);

endmodule
