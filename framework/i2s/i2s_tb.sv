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
    input logic [DW-1:0] ldac,
    input logic [DW-1:0] rdac,
    output logic rd_en,
    input logic rd_valid,
    output logic [DW-1:0] ladc,
    output logic [DW-1:0] radc,
    output logic adc_valid,
    // I2S master transmitter bus
    output logic sclk,
    output logic lrclk,
    output logic sdo,
    input logic sdi
);

i2s #(.DW(DW)) i2s0(.clk(clk));

assign sclk = i2s0.sclk;
assign lrclk = i2s0.lrclk;
assign sdo = i2s0.sdo;
assign i2s0.sdi = i2s0.sdo; // loopback.

i2s_clkgen #(
    .DW(DW),
    .FS_RATIO(FS_RATIO)
) i2s_clkgen_inst (
    .rst(rst),
    .clkgen(i2s0)
);

i2s_bi #(
    .DW(DW)
) i2s_bi_inst (
    .rst(rst),
    .i2sb(i2s0),
    .tx_ldata(ldac),
    .tx_rdata(rdac),
    .tx_rd_en(rd_en),
    .tx_rd_valid(rd_valid),
    .rx_ldata(ladc),
    .rx_rdata(radc),
    .rx_valid(adc_valid)
);
// i2s_tx #(
//     .DW(DW)
// ) i2sm_tx_inst (
//     .rst(rst),
//     .tx(i2s0),
//     .l_sample(l_sample),
//     .r_sample(r_sample),
//     .rd_en(rd_en),
//     .rd_valid(rd_valid)
// );

// i2s_rx #(
//     .DW(DW)
// ) i2s_rx_inst (
//     .rst(rst),
//     .rx(i2s0),
//     .l_sample(l_adc),
//     .r_sample(r_adc),
//     .valid(adc_valid)
// );

endmodule
