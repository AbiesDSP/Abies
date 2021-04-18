`timescale 1ns/1ps

`include "i2s.sv"

// Wrapper for i2sm_tx that doesn't use interface ports.
module i2s_tb #(
    // Number of bits transmitted. This module will not pad any data.
    parameter DW = 24,
    // Sampling frequency ratio MCLK/LRCLK. 12.288MHz / 256 = 48kHz. 128: 96kHz
    parameter FS_RATIO = 256
) (
    input logic clk,
    input logic rst,
    input logic [DW-1:0] l_sample,
    input logic [DW-1:0] r_sample,
    output logic rd_en,
    input logic rd_valid,
    // I2S master transmitter bus
    output logic sclk,
    output logic lrclk,
    output logic sdo
);

i2s #(.DW(DW)) i2s0(.clk(clk));

assign sclk = i2s0.sclk;
assign lrclk = i2s0.lrclk;
assign sdo = i2s0.sdo;

i2s_clkgen #(
    .DW(DW),
    .FS_RATIO(FS_RATIO)
) i2s_clkgen_inst (
    .clk(clk),
    .rst(rst),
    .clkgen(i2s0)
);

i2s_tx #(
    .DW(DW)
) i2sm_tx_inst (
    .clk(clk),
    .rst(rst),
    .l_sample(l_sample),
    .r_sample(r_sample),
    .rd_en(rd_en),
    .rd_valid(rd_valid),
    .tx(i2s0)
);

endmodule
