`timescale 1ns/1ps

module cpu_pip();

reg clk = 0;
always #5 clk = ~clk;

reg reset = 0;

wire [31:0] PC, PC_plus4, instruction, nextPC;

PCReg pc_reg (.clk(clk), .nextPC(nextPC), .PC(PC));
PCInc pc_inc (.clk(clk), .oldPC(PC), .newPC(PC_plus4));

BankedMEM IMEM (
    .clk(clk),
    .writeEn(0),
    .address(PC),
    .writeData(0),
    .readData(instruction)
);

reg [31:0] IF_ID_PC, IF_ID_inst;

always @(posedge clk) begin
    IF_ID_PC   <= PC;
    IF_ID_inst <= instruction;
end

wire [31:0] regData1, regData2, immOut;
wire [2:0] funct3;

wire RegWrite, ALUSrc, MemWrite, MemRead, Branch;
wire [2:0] ALUOp;
wire [1:0] RdSrc, ImmSel;

ControlUnit CU (
    .inst(IF_ID_inst),
    .AlUSrca(),
    .RegWrite(RegWrite),
    .ALUSrc(ALUSrc),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .ALUOp(ALUOp),
    .ImmSel(ImmSel),
    .RdSrc(RdSrc),
    .Branch(Branch),
    .funct3_out(funct3)
);

immgen IG (
    .immSel(ImmSel),
    .inst(IF_ID_inst),
    .immOut(immOut)
);

reg_file RF (
    .clk(clk),
    .reset(0),
    .rs1(IF_ID_inst[19:15]),
    .rs2(IF_ID_inst[24:20]),
    .rd(MEM_WB_rd),
    .wd(writeBackData),
    .we(MEM_WB_RegWrite),
    .rdata1(regData1),
    .rdata2(regData2)
);

reg [31:0] ID_EX_PC, ID_EX_rs1, ID_EX_rs2, ID_EX_imm;
reg [4:0]  ID_EX_rd;
reg [2:0]  ID_EX_ALUOp, ID_EX_funct3;
reg        ID_EX_ALUSrc, ID_EX_MemRead, ID_EX_MemWrite, ID_EX_RegWrite, ID_EX_Branch;
reg [1:0]  ID_EX_MemToReg;

always @(posedge clk) begin
    ID_EX_PC       <= IF_ID_PC;
    ID_EX_rs1      <= regData1;
    ID_EX_rs2      <= regData2;
    ID_EX_imm      <= immOut;
    ID_EX_rd       <= IF_ID_inst[11:7];
    ID_EX_ALUOp    <= ALUOp;
    ID_EX_ALUSrc   <= ALUSrc;
    ID_EX_MemRead  <= MemRead;
    ID_EX_MemWrite <= MemWrite;
    ID_EX_RegWrite <= RegWrite;
    ID_EX_MemToReg <= RdSrc;
    ID_EX_Branch   <= Branch;
    ID_EX_funct3   <= funct3;
end

wire [31:0] aluResult;
wire [31:0] aluB;
assign aluB = (ID_EX_ALUSrc) ? ID_EX_imm : ID_EX_rs2;

wire zero;

rv32ialu ALU (
    .A(ID_EX_rs1),
    .B(aluB),
    .alu_ctrl(ID_EX_ALUOp),
    .Y(aluResult),
    .zero(zero)
);

wire branch_taken;
assign branch_taken =
    (ID_EX_funct3 == 3'b000 && zero) ||
    (ID_EX_funct3 == 3'b001 && ~zero);

assign nextPC = (ID_EX_Branch && branch_taken) ? aluResult : PC_plus4;

reg [31:0] EX_MEM_alu, EX_MEM_rs2;
reg [4:0]  EX_MEM_rd;
reg        EX_MEM_MemRead, EX_MEM_MemWrite, EX_MEM_RegWrite;
reg [1:0]  EX_MEM_MemToReg;

always @(posedge clk) begin
    EX_MEM_alu      <= aluResult;
    EX_MEM_rs2      <= ID_EX_rs2;
    EX_MEM_rd       <= ID_EX_rd;
    EX_MEM_MemRead  <= ID_EX_MemRead;
    EX_MEM_MemWrite <= ID_EX_MemWrite;
    EX_MEM_RegWrite <= ID_EX_RegWrite;
    EX_MEM_MemToReg <= ID_EX_MemToReg;
end

wire [31:0] memReadData;

BankedMEM DMEM (
    .clk(clk),
    .writeEn(EX_MEM_MemWrite),
    .address(EX_MEM_alu),
    .writeData(EX_MEM_rs2),
    .readData(memReadData)
);

reg [31:0] MEM_WB_mem, MEM_WB_alu;
reg [4:0]  MEM_WB_rd;
reg        MEM_WB_RegWrite;
reg [1:0]  MEM_WB_MemToReg;

always @(posedge clk) begin
    MEM_WB_mem      <= memReadData;
    MEM_WB_alu      <= EX_MEM_alu;
    MEM_WB_rd       <= EX_MEM_rd;
    MEM_WB_RegWrite <= EX_MEM_RegWrite;
    MEM_WB_MemToReg <= EX_MEM_MemToReg;
end

wire [31:0] writeBackData;

assign writeBackData =
    (MEM_WB_MemToReg == 2'b00) ? MEM_WB_alu :
    (MEM_WB_MemToReg == 2'b01) ? MEM_WB_mem :
    32'b0;

endmodule