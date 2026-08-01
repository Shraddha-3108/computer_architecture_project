`timescale 1ns/1ps
module cpu_sc_part();

reg clk = 0;
always #5 clk = ~clk;   // 10ns clock

wire [31:0] PC;
wire [31:0] nextPC;
wire [31:0] instruction;

wire RegWrite;
wire ALUSrc;
wire MemWrite;
wire MemRead;
wire [2:0] ALUOp;
wire [1:0] ImmSel;

wire [31:0] immOut;
wire [31:0] regData1;
wire [31:0] regData2;
wire [31:0] aluInputB;
wire [31:0] aluResult;
wire [31:0] memReadData;
wire [31:0] writeBackData;


PCReg pc_reg (
    .clk(clk),
    .nextPC(nextPC),
    .PC(PC)
);


PCInc pc_inc (
    .clk(clk),
    .oldPC(PC),
    .newPC(nextPC)
);


BankedMEM IMEM (
    .clk(clk),
    .writeEn(1'b0),      // IMEM is read-only
    .address(PC),
    .writeData(32'b0),
    .readData(instruction)
);


ControlUnit CU (
    .inst(instruction),
    .RegWrite(RegWrite),
    .ALUSrc(ALUSrc),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .ALUOp(ALUOp),
    .ImmSel(ImmSel)
);

immgen IG (
    .immSel(ImmSel),
    .inst(instruction),
    .immOut(immOut)
);


reg_file RF (
    .clk(clk),
    .reset(reset),
    .rs1(instruction[19:15]),
    .rs2(instruction[24:20]),
    .rd(instruction[11:7]),
    .wd(writeBackData),
    .we(RegWrite),
    .rdata1(regData1),
    .rdata2(regData2)

);
assign aluInputB = (ALUSrc) ? immOut : regData2;


rv32ialu ALU (
    .A(regData1),
    .B(aluInputB),
    .alu_ctrl(ALUOp),
    .Y(aluResult),
    .zero()              
);


BankedMEM DMEM (
    .clk(clk),
    .writeEn(MemWrite),
    .address(aluResult),
    .writeData(regData2),
    .readData(memReadData)
);
assign writeBackData = (MemRead) ? memReadData : aluResult;

endmodule