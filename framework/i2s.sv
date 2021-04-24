// Use same sclk and lrclk for rx and tx.
module i2s #(
    parameter DW = 24
) (
    input logic clk,
    input logic rst,
    input logic [DW-1:0] tx_ldata,
    input logic [DW-1:0] tx_rdata,
    output logic tx_rd_en,
    input logic tx_rd_valid,
    output logic [DW-1:0] rx_ldata,
    output logic [DW-1:0] rx_rdata,
    output logic rx_valid,
    //
    input logic sclk,
    input logic lrclk,
    output logic sdo,
    input logic sdi
);

i2s_tx #(
    .DW(DW)
) i2s_tx_inst (
    .clk(clk),
    .rst(rst),
    .ldata(tx_ldata),
    .rdata(tx_rdata),
    .rd_en(tx_rd_en),
    .rd_valid(tx_rd_valid),
    .sclk(sclk),
    .lrclk(lrclk),
    .sdo(sdo)
);

i2s_rx #(
    .DW(DW)
) i2s_rx_inst (
    .clk(clk),
    .rst(rst),
    .ldata(rx_ldata),
    .rdata(rx_rdata),
    .valid(rx_valid),
    .sclk(sclk),
    .lrclk(lrclk),
    .sdi(sdi)
);

endmodule
