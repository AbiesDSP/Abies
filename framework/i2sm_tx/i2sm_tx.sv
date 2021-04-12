`default_nettype none
`include "audio_bus.sv"

// I2S module will run at 12.288MHz, independent of the framework bus clock.
// It will pull data from an asynchronous fifo.
module i2sm_tx #(
    // Number of bits transmitted. This module will not pad any data.
    parameter DW = 24,
    // Sampling frequency ratio MCLK/LRCLK. 12.288MHz / 256 = 48kHz. 128: 96kHz
    parameter FS_RATIO = 255,
    localparam LR_CTR_SIZE = $clog2(FS_RATIO)
) (
    // I2S master transmitter bus
    i2s_b.m_tx i2s_o,
    input logic en,
    output logic rd_en, // Connect to fifo.
    input logic i_valid,
    input logic [DW-1:0] i_sample
);

/* verilator lint_off WIDTH */
// Skid buffer inputs?

logic clk;
assign clk = i2s_o.mclk;

// Counter to set LR clock
logic [LR_CTR_SIZE-1:0] lr_ctr;

initial lr_ctr = 0;
initial i2s_o.lrclk = 0;

// LR clock divider to generate lrclk and sclk
always @(posedge clk) begin
    lr_ctr <= lr_ctr + 1;
    if (lr_ctr == 0) begin
        i2s_o.lrclk <= !i2s_o.lrclk;
    end
    // sclk is half 
    if (lr_ctr & 1) begin
        i2s_o.sclk <= 1;
    end else begin
        i2s_o.sclk <= 0;
    end
end

// Input buffer
logic [DW-1:0] sample_r;
// Bit counter
// Need to count to 2*DW for whole message.
logic [$clog2(DW << 1):0] counter;
initial counter = 0;
//
always @(posedge clk) begin
    if (i_valid) begin
        sample_r <= i_sample;
    end
end

logic lr_last;
//
always @(posedge clk) begin
    lr_last <= i2s_o.lrclk;
    // Falling edge of lrclk. Clock in new sample.
    if (lr_last && !i2s_o.lrclk) begin
        counter <= 0;
    end
end
endmodule
