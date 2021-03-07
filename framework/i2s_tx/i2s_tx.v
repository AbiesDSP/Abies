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

// Number of bits transmitted. This module will not pad any data.
parameter DW = 24;
// Sampling frequency ratio MCLK/LRCLK. 12.288MHz / 256 = 48kHz. 128: 96kHz
parameter FS_RATIO = 256;

// Bit counter
// Need to count to 2*DW for whole message.
reg [$clog2(DW << 1):0] counter;

// Skid buffer inputs?

// Module and device use same clock.
assign mclk = clk;


endmodule
