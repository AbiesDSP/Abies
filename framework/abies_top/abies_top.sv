`timescale 1ns/1ns

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

assign dac_mclk = clk;

logic rst = 0;
logic rd_en, rd_early, rd_valid;
logic lrclk_prev = 0;
logic signed [DW-1:0] dds_sample;
// logic signed [3:0] gain_shift = 2;

logic [15:0] tuning = 32768;
logic signed [DW-1:0] dds_scaled;

assign dds_scaled = dds_sample / 8;

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
    .ce(rd_early),
    .valid(rd_valid),
    .tuning_word(tuning),
    .ampl(dds_sample),
    .start_phase(0),
    .wfm_wea(),
    .wfm_waddr(),
    .wfm_din()
);

assign rd_early = lrclk_prev & !dac_lrclk;
always @(posedge clk) begin
    lrclk_prev <= dac_lrclk;
end

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
    .l_sample(dds_scaled),
    .r_sample(dds_scaled),
    .rd_en(rd_en),
    .rd_valid(rd_valid),
    .sclk(dac_sclk),
    .lrclk(dac_lrclk),
    .sdo(dac_sdi)
);

endmodule
