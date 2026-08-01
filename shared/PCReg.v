module PCReg(
    input clk,
    input [31:0] nextPC,
    output reg [31:0] PC
);

initial PC = 0;

always @(posedge clk)
    PC <= nextPC;

endmodule