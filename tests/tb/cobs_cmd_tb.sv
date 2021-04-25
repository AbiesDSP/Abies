module cobs_cmd_tb #(
    localparam IW = 8,
    localparam AW = 8,
    localparam DW = 24
) (
    input  logic clk,
    input  logic rst,
    input  logic [IW-1:0] i_data,
    input  logic i_valid,
    output logic error,
    output logic o_ready,
    output logic [AW-1:0] o_addr,
    output logic [DW-1:0] o_data,
    output logic o_valid
);

logic [IW-1:0] cobs_odata;
logic cobs_valid, cobs_last, cmd_ready;

cobs_decode cobs_decode_inst (
    .clk(clk),
    .rst(rst),
    .error(error),
    .i_data(i_data),
    .i_valid(i_valid),
    .o_ready(o_ready),
    .o_data(cobs_odata),
    .o_valid(cobs_valid),
    .i_ready(cmd_ready),
    .o_last(cobs_last)
);

cmd_parse #(
    .AW(8),
    .DW(24),
    .FRAME_BYTES(5)
) cmd_parse_inst (
    .clk(clk),
    .rst(rst),
    .i_data(cobs_odata),
    .i_valid(cobs_valid),
    .o_ready(cmd_ready),
    .i_last(cobs_last),
    .o_addr(o_addr),
    .o_data(o_data),
    .o_valid(o_valid)
);

endmodule
