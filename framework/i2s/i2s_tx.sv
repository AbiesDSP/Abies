`timescale 1ns/1ps
// I2S module will run at 12.288MHz, independent of the framework bus clock.
// It will pull data from an asynchronous fifo.
module i2s_tx #(
    // Number of bits transmitted. This module will not pad any data.
    parameter DW = 24
) (
    input logic clk,
    input logic rst,
    // Fifo Interface
    input logic [DW-1:0] l_sample,
    input logic [DW-1:0] r_sample,
    output logic rd_en,
    input logic rd_valid,
    // I2S Interface
     input logic sclk,
    input logic lrclk,
    output logic sdo
);

logic sclk_prev = 0, lrclk_prev = 1;
logic [DW-1:0] sdo_reg = 0, r_reg = 0;
logic sdo_pipe = 0;
logic r_load = 0;

assign sdo = sdo_pipe;

// SDO shift register.
always @(posedge clk) begin
    rd_en <= 0;
    r_load <= 0;
    // L sample, request from fifo.
    if (!lrclk & lrclk_prev)
        rd_en <= 1;
    // R sample
    if (lrclk & !lrclk_prev)
        r_load <= 1;
    
    if (rd_valid) begin
        sdo_reg <= l_sample;
        r_reg <= r_sample;
    end else if (r_load) begin
        sdo_reg <= r_reg;
    end else if (!sclk & sclk_prev) begin
        // Shift data on falling edge
        sdo_reg <= {sdo_reg[DW-2:0], 1'b0};
        // One pipeline because of i2s.
        sdo_pipe <= sdo_reg[DW-1];
    end
end

// Rising edge detectors
always_ff @(posedge clk) begin
    sclk_prev <= sclk;
    lrclk_prev <= lrclk;
end

endmodule
