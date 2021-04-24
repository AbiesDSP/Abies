module cobs_encode #(
    // Maximum number of bytes to encode.
    parameter MAX = 64,
    localparam DW = 8
) (
    input logic clk,
    input logic rst,
    input logic [DW-1:0] i_data,
    input logic i_valid,
    input logic i_last,
    output logic [DW-1:0] o_data,
    output logic o_valid,
    output logic o_last
);

endmodule
