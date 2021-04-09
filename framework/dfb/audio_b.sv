`ifndef AUDIO_B
`define AUDIO_B
`default_nettype none
interface audio_b #(parameter DW = 24);
    logic valid;
    logic ready;
    logic [DW-1:0] data;

    // Input port
    modport din(
        input valid, data,
        output ready
    );
    modport dout (
        input ready,
        output valid, data
    );
endinterface
`endif
