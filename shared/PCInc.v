`timescale 1ns/1ps
module PCInc (
    input clk,
    input [31:0] oldPC,
    output[31:0] newPC
);
wire [31:0] four;
assign four = 32'd4;
aluaddsub u_addsub (
        .A(oldPC),
        .B(four),
        .sub(1'b0),  
        .Y(newPC)
    );
endmodule