`timescale 1ns/1ns
`include "i2s.sv"

module abies_top #(
    parameter DW = 24,
    parameter FS_RATIO = 256,
    parameter WFM_FILE = "sin_w24_d10.mem",
    parameter DEPTH = 1024
) (
    input logic clk,
    // input logic rst,
    output logic dac_mclk,
    output logic dac_sclk,
    output logic dac_lrclk,
    output logic dac_sdi,
    input logic btn[2],
    output logic led[2],
    output logic [2:0] rgb
);

// Turn unused leds off.
assign led[0] = 0;
assign led[1] = 1;
assign rgb[0] = 1;
assign rgb[1] = 1;
assign rgb[2] = 1;

logic rst = 0;
logic rd_en, rd_valid;
logic lrclk_prev = 0;
logic signed [DW-1:0] dds_sample;

logic [15:0] tuning = 32768;
logic signed [DW-1:0] dds_scaled;

assign dds_scaled = dds_sample / 8;

dds #(
    .WFM_FILE(WFM_FILE),
    .DEPTH(DEPTH),
    .TW(16),
    .OW(DW),
    .PW(22),
    .TABLE_TYPE("FULL"),
    .RAM_PERFORMANCE("LOW_LATENCY")
) dds_inst (
    .clk(clk),
    .rst(rst),
    .ce(rd_en),
    .valid(rd_valid),
    .tuning_word(tuning),
    .ampl(dds_sample),
    .start_phase(0),
    .wfm_wea(),
    .wfm_waddr(),
    .wfm_din()
);

i2s #(.DW(DW)) dac_i2s(.clk(clk));

assign dac_mclk = dac_i2s.clk;
assign dac_sclk = dac_i2s.sclk;
assign dac_lrclk = dac_i2s.lrclk;
assign dac_sdi = dac_i2s.sdo;

i2s_clkgen #(
    .DW(DW),
    .FS_RATIO(FS_RATIO)
) i2s_clkgen_inst (
    .clk(clk),
    .rst(rst),
    .clkgen(dac_i2s)
);

i2s_tx #(
    .DW(DW)
) i2sm_tx_inst (
    .clk(clk),
    .rst(rst),
    .l_sample(dds_scaled),
    .r_sample(dds_scaled),
    .rd_en(rd_en),
    .rd_valid(rd_valid),
    .tx(dac_i2s)
);

endmodule
