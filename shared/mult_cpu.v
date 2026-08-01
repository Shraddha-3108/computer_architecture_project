module mult_cpu(
    input clk,
    input rst
);

    // =========================
    // μPC (state)
    // =========================
    wire [7:0] state;

    // =========================
    // Control <-> Sequencer
    // =========================
    wire [2:0] uBr;
    wire [7:0] next;

    // =========================
    // Datapath status signals
    // =========================
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire zero;
    wire busy;

    // =========================
    // Control signals
    // =========================
    wire IRLd;
    wire RegWr;
    wire RegEn;
    wire [2:0] RegSel;

    wire ALd;
    wire BLd;
    wire MALd;

    wire [2:0] ALUOp;
    wire ALUEn;

    wire MemWr;
    wire MemEn;

    wire [2:0] ImmSel;
    wire ImmEn;

    // =========================
    // Microsequencer
    // =========================
    mult_seq SEQ (
        .clk(clk),
        .reset(rst),
        .uBr(uBr),
        .next(next),
        .zero(zero),
        .busy(busy),
        .IR({funct7, funct3, 5'b0, opcode}), // reconstructed IR fields
        .state(state)
    );

    // =========================
    // Control ROM
    // =========================
    mult_ctrl CTRL (
        .state(state),
        .IR({funct7, funct3, 5'b0, opcode}),

        .IRLd(IRLd),
        .RegWr(RegWr),
        .RegEn(RegEn),
        .RegSel(RegSel),

        .ALd(ALd),
        .BLd(BLd),
        .MALd(MALd),

        .ALUOp(ALUOp),
        .ALUEn(ALUEn),

        .MemWr(MemWr),
        .MemEn(MemEn),

        .ImmSel(ImmSel),
        .ImmEn(ImmEn),

        .uBr(uBr),
        .next(next)
    );

    // =========================
    // Datapath
    // =========================
    datapath DP (
        .clk(clk),
        .rst(rst),

        // control
        .IRLd(IRLd),
        .RegSel(RegSel),
        .RegWr(RegWr),
        .RegEn(RegEn),

        .ALd(ALd),
        .BLd(BLd),
        .ALUOp(ALUOp),
        .ALUEn(ALUEn),

        .MALd(MALd),
        .MemWr(MemWr),
        .MemEn(MemEn),

        .ImmSel(ImmSel),
        .ImmEn(ImmEn),

        // outputs
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .zero(zero),
        .busy(busy)
    );

endmodule