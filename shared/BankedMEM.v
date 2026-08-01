`timescale 1ns/1ps
module BankedMEM (
    input clk,
    input writeEn,
    input [31:0] address,
    input [31:0] writeData,
    output[31:0] readData
);

reg [7:0] b0 [0:1023];
reg [7:0] b1 [0:1023];
reg [7:0] b2 [0:1023];
reg [7:0] b3 [0:1023];

wire [9:0] memAddr;
assign memAddr = address[11:2];

assign readData = {b3[memAddr],b2[memAddr],b1[memAddr],b0[memAddr]};

always @(posedge clk)
begin
    if (writeEn) begin
        b0[memAddr] <= writeData[7:0];
        b1[memAddr] <= writeData[15:8];
        b2[memAddr] <= writeData[23:16];
        b3[memAddr] <= writeData[31:24];
    end
end

endmodule