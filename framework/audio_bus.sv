`ifndef __AUDIO_B__
`define __AUDIO_B__

interface audio_bus #(parameter DW = 24) (input logic clk);

    logic valid;
    logic ready;
    logic [DW-1:0] data;

    // Input port
    modport din(
        input clk, valid, data,
        output ready
    );
    // Output port
    modport dout (
        input ready,
        output valid, data
    );
endinterface

interface i2s_b #(parameter DW = 24) (input logic mclk);

    logic sclk;
    logic lrclk;
    logic sdi;
    logic sdo;

    // DAC Driver
    modport m_tx (
        input mclk,
        output sclk, lrclk, sdo
    );
    // ADC Driver
    modport m_rx (
        input mclk, sdi,
        output sclk, lrclk
    );
    // Bidirectional Driver
    modport m_bi (
        input mclk, sdi,
        output sclk, lrclk, sdo
    );
    // DAC receiver (DAC IC)
    modport s_rx (
        input mclk, sclk, lrclk, sdo
    );
    // ADC transmitter (ADC IC)
    modport s_tx (
        input mclk, sclk, lrclk,
        output sdi
    );
    // Bidirectional
    modport s_bi (
        input mclk, sclk, lrclk, sdo,
        output sdi
    );

endinterface
`endif
