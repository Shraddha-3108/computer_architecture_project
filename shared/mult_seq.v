module mult_seq(
    input clk,
    input reset,

    // from control store (mult_ctrl)
    input [2:0] uBr,
    input [7:0] next,

    // status signals
    input zero,
    input busy,

    // instruction register
    input [31:0] IR,

    // output μPC
    output reg [7:0] state
);

    reg [7:0] next_state;

    // =========================
    // Next-state logic
    // =========================
    always @(*) begin
        case (uBr)

            3'b000: next_state = state + 1;   // N (next)

            3'b001: next_state = next;        // J (jump)

            3'b010: next_state = (zero) ? next : state + 1;   // EZ

            3'b011: next_state = (!zero) ? next : state + 1;  // NZ (for BNE)

            // -------------------------
            // Dispatch (decode instruction)
            // -------------------------
            3'b100: begin
                case (IR[6:0])  // opcode

                    // R-type: ADD / SUB
                    7'b0110011: begin
                        if (IR[30] == 1'b0)
                            next_state = 8'd10; // ADD
                        else
                            next_state = 8'd20; // SUB
                    end

                    // I-type: ADDI / XORI
                    7'b0010011: begin
                        case (IR[14:12])
                            3'b000: next_state = 8'd30; // ADDI
                            3'b100: next_state = 8'd40; // XORI
                            default: next_state = 8'd0;
                        endcase
                    end

                    // Load
                    7'b0000011: next_state = 8'd50; // LW

                    // Store
                    7'b0100011: next_state = 8'd60; // SW

                    // Branch (BNE)
                    7'b1100011: begin
                        if (IR[14:12] == 3'b001)
                            next_state = 8'd70; // BNE
                        else
                            next_state = 8'd0;
                    end

                    default: next_state = 8'd0; // fallback to FETCH
                endcase
            end

            // -------------------------
            // Stall (memory busy)
            // -------------------------
            3'b101: next_state = (busy) ? state : state + 1;

            default: next_state = state + 1;

        endcase
    end

    // =========================
    // State register (μPC)
    // =========================
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= 8'd0;   // FETCH0
        else
            state <= next_state;
    end

endmodule