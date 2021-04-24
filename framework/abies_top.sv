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
    output logic dac_sdo,
    output logic adc_mclk,
    output logic adc_sclk,
    output logic adc_lrclk,
    input logic adc_sdi,
    input logic btn[2],
    output logic led[2],
    output logic [2:0] rgb,
    output logic ftdi_rx,
    input logic ftdi_tx
);

logic led_toggle = 0;

// Turn unused leds off.
assign led[0] = led_toggle;
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

logic [DW-1:0] ladc, radc;
logic adc_valid;

logic i2s_sclk, i2s_lrclk;

logic [7:0] uart_rx_data, cmd_dec_data;
logic uart_rx_valid, cmd_dec_ready, cmd_dec_valid, cmd_dec_last;
logic last_prev = 0;

assign dac_mclk = clk;
assign dac_sclk = i2s_sclk;
assign dac_lrclk = i2s_lrclk;
// assign dac_sdo = i2s_sdo;

assign adc_mclk = clk;
assign adc_sclk = i2s_sclk;
assign adc_lrclk = i2s_lrclk;
// assign i2sb.sdi = adc_sdi;

i2s_clkgen #(
    .DW(DW),
    .FS_RATIO(FS_RATIO)
) i2s_clkgen_inst (
    .clk(clk),
    .rst(rst),
    .sclk(i2s_sclk),
    .lrclk(i2s_lrclk)
);

i2s #(
    .DW(DW)
) i2s_inst (
    .clk(clk),
    .rst(rst),
    .tx_ldata(dds_scaled),
    .tx_rdata(dds_scaled),
    .tx_rd_en(rd_en),
    .tx_rd_valid(rd_valid),
    .rx_ldata(ladc),
    .rx_rdata(radc),
    .rx_valid(adc_valid),
    .sclk(i2s_sclk),
    .lrclk(i2s_lrclk),
    .sdo(dac_sdo),
    .sdi(adc_sdi)
);

// BAUD 26: 57600
uart #(
    .DATA_WIDTH(8),
    .PRESCALE(26)
) uart_main (
    .clk(clk),
    .rst(rst),
    .s_axis_tdata(0),
    .s_axis_tvalid(0),
    .s_axis_tready(),
    .m_axis_tdata(uart_rx_data),
    .m_axis_tvalid(uart_rx_valid),
    .m_axis_tready(cmd_dec_ready),
    .rxd(ftdi_tx),
    .txd(ftdi_rx),
    .tx_busy(),
    .rx_busy(),
    .rx_overrun_error(),
    .rx_frame_error()
);

cobs_decode cmd_decode (
    .clk(clk),
    .rst(rst),
    .error(),
    .i_data(uart_rx_data),
    .i_valid(uart_rx_valid),
    .o_ready(cmd_dec_ready),
    .o_data(cmd_dec_data),
    .o_valid(cmd_dec_valid),
    .i_ready(1),
    .o_last(cmd_dec_last)
);

//always @(posedge clk) begin
//    last_prev <= cmd_dec_last;
//    if (cmd_dec_last & !last_prev) begin
//        led_toggle <= !led_toggle;
//    end
//end

endmodule
