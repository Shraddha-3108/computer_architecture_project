module branch_comparator (
    input  [31:0] rs1_data,
    input  [31:0] rs2_data,
    output        beq
);

assign beq = (rs1_data == rs2_data);

endmodule