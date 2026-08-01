`timescale 1ns/1ps

module rv32ialu (
    input  signed [31:0] A,
    input  signed [31:0] B,
    input  [2:0] alu_ctrl,
    output reg signed [31:0] Y,
    output zero
);

    // Parallel outputs
    wire signed [31:0] addsub_out;
    wire signed [31:0] logic_out;
    wire signed [31:0] shift_out;
    wire signed [31:0] slt_out;

    // ----------------------------------------------------
    // Submodules (parallel computation)
    // ----------------------------------------------------

    // ADD / SUB
    aluaddsub u_addsub (
        .A(A),
        .B(B),
        .sub(~alu_ctrl[0]),   // 000=SUB, 001=ADD
        .Y(addsub_out)
    );

    // AND / OR
    alulogic u_logic (
        .A(A),
        .B(B),
        .op(alu_ctrl[0]),     // 0=AND, 1=OR
        .Y(logic_out)
    );

    // SLL / SRL
    alushift u_shift (
        .A(A),
        .B(B),
        .dir(alu_ctrl[0]),    // 0=SLL, 1=SRL
        .Y(shift_out)
    );

    // SLT
    alucomp u_comp (
        .A(A),
        .B(B),
        .Y(slt_out)
    );

    // ----------------------------------------------------
    // Output MUX (#1 delay)
    // ----------------------------------------------------

    always @(*) begin
        #1;
        case (alu_ctrl)
            3'b000: Y = addsub_out;  // SUB
            3'b001: Y = addsub_out;  // ADD
            3'b010: Y = logic_out;   // AND
            3'b011: Y = logic_out;   // OR
            3'b100: Y = shift_out;   // SLL
            3'b101: Y = shift_out;   // SRL
            3'b110: Y = slt_out;     // SLT
            default: Y = 32'b0;      // Reserved
        endcase
    end

    // Zero flag (#1 delay)
    assign #1 zero = (Y == 32'b0);

endmodule
