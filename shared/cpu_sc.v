`timescale 1ns/1ps
module cpu_sc();

reg clk = 0;
always #5 clk = ~clk;   // 10ns clock

// -------------------- Signals --------------------
wire [31:0] PC;
wire [31:0] nextPC;
wire [31:0] PC_plus4;
wire [31:0] instruction;

wire RegWrite, ALUSrc, MemWrite, MemRead;
wire [2:0] ALUOp;
wire [1:0] ImmSel, RdSrc;
wire ALUSrca, PCSrc;
wire beq;

wire [31:0] immOut;
wire [31:0] regData1;
wire [31:0] regData2;
wire [31:0] aluInputA;
wire [31:0] aluInputB;
wire [31:0] aluResult;
wire [31:0] memReadData;
wire [31:0] writeBackData;

// -------------------- PC Register --------------------
PCReg pc_reg (
    .clk(clk),
    .nextPC(nextPC),
    .PC(PC)
);

// -------------------- PC Incrementor--------------------
PCInc pc_inc (
    .clk(clk),
    .oldPC(PC),
    .newPC(PC_plus4)
);

// -------------------- Instruction Memory --------------------
BankedMEM IMEM (
    .clk(clk),
    .writeEn(1'b0),
    .address(PC),
    .writeData(32'b0),
    .readData(instruction)
);

// -------------------- Comparator --------------------
branch_comparator BC (
    .rs1_data(regData1),
    .rs2_data(regData2),
    .beq(beq)
);
// -------------------- Control Unit --------------------
ControlUnit CU (
    .inst(instruction),
    .beq(beq),
    .AlUSrca(ALUSrca),
    .RegWrite(RegWrite),
    .ALUSrc(ALUSrc),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .ALUOp(ALUOp),
    .ImmSel(ImmSel),
    .PCSrc(PCSrc),
    .RdSrc(RdSrc)
);

// -------------------- Immediate Generator --------------------
immgen IG (
    .immSel(ImmSel),
    .inst(instruction),
    .immOut(immOut)
);

// -------------------- Register File --------------------
reg_file RF (
    .clk(clk),
    .reset(1'b0),
    .rs1(instruction[19:15]),
    .rs2(instruction[24:20]),
    .rd(instruction[11:7]),
    .wd(writeBackData),
    .we(RegWrite),
    .rdata1(regData1),
    .rdata2(regData2)
);

// -------------------- ALU Input MUX --------------------
assign aluInputA = (ALUSrca) ? PC : regData1;
assign aluInputB = (ALUSrc)  ? immOut : regData2;

// -------------------- ALU --------------------
rv32ialu ALU (
    .A(aluInputA),
    .B(aluInputB),
    .alu_ctrl(ALUOp),
    .Y(aluResult),
    .zero()
);

// -------------------- Data Memory --------------------
BankedMEM DMEM (
    .clk(clk),
    .writeEn(MemWrite),
    .address(aluResult),
    .writeData(regData2),
    .readData(memReadData)
);

// -------------------- Writeback MUX --------------------
assign writeBackData =
    (RdSrc == 2'b00) ? aluResult   :   // ALU
    (RdSrc == 2'b01) ? memReadData :   // LW
    (RdSrc == 2'b10) ? PC_plus4    :   // JAL
    32'b0;

// -------------------- PC Selection MUX --------------------
assign nextPC = (PCSrc) ? aluResult : PC_plus4;

endmodule