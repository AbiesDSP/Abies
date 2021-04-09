`default_nettype none

module dfb_tb(
    input logic clk,
    input logic i_valid,
    output logic o_ready,
    input logic [23:0] i_data,
    output logic o_valid,
    input logic i_ready,
    output logic [23:0] o_data
);

audio_b if0();
audio_b if1();
audio_b if2();
assign if0.dout.valid = i_valid;
assign if0.dout.data = i_data;
assign o_ready = if0.dout.ready;

assign o_valid = if2.din.valid;
assign o_data = if2.din.data;
assign if2.din.ready = i_ready;
// assign if0.din.valid = i_valid;
// assign if0.din.ready = o_ready;
// assign if0.din.data = i_data;

dfb dut0(.clk(clk), .din(if0), .dout(if1));
dfb dut1(.clk(clk), .din(if1), .dout(if2));

endmodule
