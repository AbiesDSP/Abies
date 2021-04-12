`default_nettype none
`include "audio_bus.sv"

module dfb (
    audio_bus.din din,
    audio_bus.dout dout
);

logic clk;
assign clk = din.clk;

assign din.ready = 1;

always_ff @(posedge clk) begin
    dout.valid <= din.valid;
    if (din.valid)
        dout.data <= din.data;
end
endmodule
