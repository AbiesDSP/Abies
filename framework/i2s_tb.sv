module i2s_tb #(
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
    output logic sclk,
    output logic lrclk,
    output logic sdo,
    output logic sdi
);

// loopback
assign sdi = sdo;

i2s_clkgen #(
    .DW(DW)
) i2s_clkgen_inst (
    .clk(clk),
    .rst(rst),
    .sclk(sclk),
    .lrclk(lrclk)
);

i2s #(
    .DW(DW)
) i2s_inst (
    .clk(clk),
    .rst(rst),
    .tx_ldata(tx_ldata),
    .tx_rdata(tx_rdata),
    .tx_rd_en(tx_rd_en),
    .tx_rd_valid(tx_rd_valid),
    .rx_ldata(rx_ldata),
    .rx_rdata(rx_rdata),
    .rx_valid(rx_valid),
    .sclk(sclk),
    .lrclk(lrclk),
    .sdo(sdo),
    .sdi(sdi)
);

endmodule
