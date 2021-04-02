`default_nettype none

// I2S module will run at 12.288MHz, independent of the framework bus clock.
// It will pull data from an asynchronous fifo.
module i2s_tx (
    input wire clk,
    input wire rst,
    input wire i_valid,
    output reg o_ready,
    input wire [DW-1:0] i_sample,
    // I2S signals
    output reg sdo,
    output reg sclk,
    output reg lrclk,
    output wire mclk
);

/* verilator lint_off WIDTH */

// Number of bits transmitted. This module will not pad any data.
parameter DW = 24;
// Sampling frequency ratio MCLK/LRCLK. 12.288MHz / 256 = 48kHz. 128: 96kHz
parameter FS_RATIO = 255;
parameter LR_CTR_SIZE = $clog2(FS_RATIO);
// Skid buffer inputs?

// Module and device use same clock.
assign mclk = clk;

// Counter to set LR clock
reg [LR_CTR_SIZE-1:0] lr_ctr;

initial lr_ctr = 0;
initial lrclk = 0;

// LR clock divider to generate lrclk and sclk
always @(posedge clk) begin
    lr_ctr <= lr_ctr + 1;
    if (lr_ctr == 0) begin
        lrclk <= !lrclk;
    end
    // sclk is half 
    if (lr_ctr & 1) begin
        sclk <= 1;
    end else begin
        sclk <= 0;
    end
end

// Input buffer
reg [DW-1:0] sample_r;
// Bit counter
// Need to count to 2*DW for whole message.
reg [$clog2(DW << 1):0] counter;
initial counter = 0;
//
always @(posedge clk) begin
    if (i_valid) begin
        sample_r <= i_sample;
    end
end

reg lr_last;
//
always @(posedge clk) begin
    lr_last <= lrclk;
    // Falling edge of lrclk. Clock in new sample.
    if (lr_last && !lrclk) begin
        counter <= 0;
    end
end
endmodule
