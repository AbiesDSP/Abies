`default_nettype none

module dfb_tb(
    input logic clk,
    // Input port
    input logic i_valid,
    output logic o_ready,
    input logic [23:0] i_data,
    // Output port
    output logic o_valid,
    input logic i_ready,
    output logic [23:0] o_data
);

// Audio busses
audio_bus bus0(clk);
audio_bus bus1(clk);
audio_bus bus2(clk);

// Input port driven from testbench signals.
assign bus0.dout.valid = i_valid;
assign bus0.dout.data = i_data;
assign o_ready = bus0.dout.ready;

// Connect devices.
dfb device0(.din(bus0), .dout(bus1));
dfb device1(.din(bus1), .dout(bus2));

// Output port driven from last device in the chain.
assign o_valid = bus2.din.valid;
assign o_data = bus2.din.data;
assign bus2.din.ready = i_ready;

endmodule
