`default_nettype none

// `include "audio_b.sv"

module dfb (
    input logic clk,
    audio_b.din din,
    audio_b.dout dout
);

assign din.ready = 1;

always_ff @(posedge clk) begin
    dout.valid <= din.valid;
    if (din.valid)
        dout.data <= din.data;
end
endmodule
