`timescale 1ns/1ps
module alu_ctrl (
    input  [2:0] funct3,
    input  [6:0] funct7,
    output [2:0] alu_ctrl
);

    wire is_addsub;
    wire is_and;
    wire is_or;
    wire is_sll;
    wire is_slt;

    assign #1 is_addsub = (funct3 == 3'b000);
    assign #1 is_and    = (funct3 == 3'b111);
    assign #1 is_or     = (funct3 == 3'b110);
    assign #1 is_sll    = (funct3 == 3'b001);
    assign #1 is_slt    = (funct3 == 3'b010);

    wire is_sub;
    wire is_add;

    assign #1 is_sub = is_addsub & funct7[5];
    assign #1 is_add = is_addsub & ~funct7[5];

    assign #1 alu_ctrl[2] = is_sll | is_slt;
    assign #1 alu_ctrl[1] = is_and | is_or | is_slt;
    assign #1 alu_ctrl[0] = is_add | is_or;

endmodule