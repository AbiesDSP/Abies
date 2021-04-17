`timescale 1ns/1ps

module abies_top #(
    parameter DW = 24,
    parameter FS_RATIO = 256,
    parameter WFM_FILE,
    parameter DEPTH = 1024
) (
    input logic clk,
    input logic rst,
    input logic [15:0] tuning,
    output logic dac_sclk,
    output logic dac_lrclk,
    output logic dac_sdo,
    output logic [1:0] led,
    output logic [2:0] rgb
);

// Turn unused leds off.
assign led[1] = 0;
assign rgb[0] = 1;
assign rgb[1] = 1;
assign rgb[2] = 1;

logic rd_en, rd_valid;
logic [DW-1:0] dds_sample;

dds #(
    .WFM_FILE(WFM_FILE),
    .DEPTH(DEPTH),
    .TW(16),
    .OW(DW),
    .PW(22),
    .TABLE_TYPE("QUARTER"),
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

i2s_clk #(
    .DW(DW),
    .FS_RATIO(FS_RATIO)
) i2s_clk_inst (
    .clk(clk),
    .rst(rst),
    .sclk(dac_sclk),
    .lrclk(dac_lrclk)
);

i2s_tx #(
    .DW(DW)
) i2sm_tx_inst (
    .clk(clk),
    .rst(rst),
    .l_sample(dds_sample),
    .r_sample(dds_sample),
    .rd_en(rd_en),
    .rd_valid(rd_valid),
    .sclk(dac_sclk),
    .lrclk(dac_lrclk),
    .sdo(dac_sdo)
);

endmodule
