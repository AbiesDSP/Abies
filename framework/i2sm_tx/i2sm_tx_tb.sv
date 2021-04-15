`default_nettype none

// Wrapper for i2sm_tx that doesn't use interface ports.
module i2sm_tx_tb #(
    // Number of bits transmitted. This module will not pad any data.
    parameter DW = 24,
    // Sampling frequency ratio MCLK/LRCLK. 12.288MHz / 256 = 48kHz. 128: 96kHz
    parameter FS_RATIO = 255,
    localparam LR_CTR_SIZE = $clog2(FS_RATIO)
) (
    input logic clk,
    input logic rst,
    output logic rd_en,
    input logic i_valid,
    input logic [DW-1:0] l_sample,
    input logic [DW-1:0] r_sample,
    // I2S master transmitter bus
    output logic sclk,
    output logic lrclk,
    output logic sdo
);

// Use audio clock in top-level.
i2s_b i2s0(clk);

assign sclk = i2s0.sclk;
assign lrclk = i2s0.lrclk;
assign sdo = i2s0.sdo;

i2sm_tx #(
    .DW(DW),
    .FS_RATIO(FS_RATIO)
) i2sm_tx_inst (
    .rst(rst),
    .i2s_o(i2s0),
    .rd_en(rd_en),
    .i_valid(i_valid),
    .l_sample(l_sample),
    .r_sample(r_sample)
);

endmodule
