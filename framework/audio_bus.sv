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

`endif
