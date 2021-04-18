`timescale 1ns/1ps
`include "i2s.sv"

// Use same sclk and lrclk for rx and tx.
module i2s_bi #(
    parameter DW = 24
) (
    input logic rst,
    i2s.bi i2sb,
    input logic [DW-1:0] tx_ldata,
    input logic [DW-1:0] tx_rdata,
    output logic tx_rd_en,
    input logic tx_rd_valid,
    output logic [DW-1:0] rx_ldata,
    output logic [DW-1:0] rx_rdata,
    output logic rx_valid
);

i2s_tx #(
    .DW(DW)
) i2s_tx_inst (
    .rst(rst),
    .tx(i2sb),
    .ldata(tx_ldata),
    .rdata(tx_rdata),
    .rd_en(tx_rd_en),
    .rd_valid(tx_rd_valid)
);

i2s_rx #(
    .DW(DW)
) i2s_rx_inst (
    .rst(rst),
    .rx(i2sb),
    .ldata(rx_ldata),
    .rdata(rx_rdata),
    .valid(rx_valid)
);

endmodule
