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

interface i2s_bus #(parameter DW = 24) (input logic clk, input logic rst);

    logic sclk;
    logic lrclk;
    logic sdi;
    logic sdo;

    modport i2sm (
        input sdi,
        output sclk, lrclk, sdo
    );
    
    modport i2ss (
        input sclk, lrclk, sdo,
        output output_ports
    );

endinterface
`endif
