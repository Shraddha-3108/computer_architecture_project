`timescale 1ns/1ps
module ControlUnit (
    input [31:0] inst,

    output reg AlUSrca,
    output reg RegWrite,
    output reg ALUSrc,
    output reg MemWrite,
    output reg MemRead,
    output reg [2:0] ALUOp,
    output reg [1:0] ImmSel,
    output reg [1:0] RdSrc,
    output reg Branch,

    output [2:0] funct3_out
);

wire [6:0] opcode;
wire [2:0] funct3;
wire [6:0] funct7;

assign opcode = inst[6:0];
assign funct3 = inst[14:12];
assign funct3_out = funct3;
assign funct7 = inst[31:25];

always @(*) begin

    RegWrite = 0;
    ALUSrc   = 0;
    MemWrite = 0;
    MemRead  = 0;
    ALUOp    = 3'b111; 
    ImmSel   = 2'b00;
    AlUSrca  = 0;
    RdSrc    = 2'b00;
    Branch   = 0;

    case (opcode)

        7'b0110011: begin
            RegWrite = 1;
            RdSrc = 2'b00;

            case (funct3)
                3'b000: ALUOp = (funct7 == 7'b0100000) ? 3'b000 : 3'b001;
                3'b111: ALUOp = 3'b010;
                3'b110: ALUOp = 3'b011;
            endcase
        end

        7'b0010011: begin
            RegWrite = 1;
            ALUSrc   = 1;
            ImmSel   = 2'b00;
            RdSrc = 2'b00;

            case (funct3)
                3'b000: ALUOp = 3'b001;
                3'b111: ALUOp = 3'b010;
            endcase
        end

        7'b0000011: begin
            RegWrite = 1;
            ALUSrc   = 1;
            MemRead  = 1;
            ALUOp    = 3'b001;
            ImmSel   = 2'b00;
            RdSrc    = 2'b01;
        end

        7'b0100011: begin
            ALUSrc   = 1;
            MemWrite = 1;
            ALUOp    = 3'b001;
            ImmSel   = 2'b01;
        end

        7'b1100011: begin
            Branch  = 1;
            ALUSrca = 1;
            ALUSrc  = 1;
            ALUOp   = 3'b001;
            ImmSel  = 2'b10;
        end

        7'b1101111: begin
            RegWrite = 1;
            ALUSrca  = 1;
            ALUSrc   = 1;
            ALUOp    = 3'b001;
            ImmSel   = 2'b11;
            RdSrc    = 2'b10;
        end

    endcase
end

endmodule