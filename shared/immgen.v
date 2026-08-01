`timescale 1ns/1ps
module immgen (
    input [1:0]immSel,
    input [31:0] inst,
    output[31:0] immOut
);
wire [31:0] ImmI;
wire [31:0] ImmS;
wire [31:0] ImmB;

assign ImmI = {{20{inst[31]}}, inst[31:20]};
assign ImmS = {{20{inst[31]}}, inst[31:25],inst[11:7]};
assign ImmB = {{19{inst[31]}}, inst[31],inst[7],inst[30:25],inst[11:8],1'b0};
assign ImmJ = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};

assign immOut =
(immSel == 2'b00)?ImmI:
(immSel == 2'b01)?ImmS:
(immSel == 2'b10)?ImmB:
(immSel == 2'b11)?ImmJ:
32'b0;
endmodule  