module cobs_uart_tb #(
    localparam IW = 8,
    localparam AW = 8,
    localparam DW = 24
) (
    input  logic clk,
    input  logic rst,
    input  logic [IW-1:0] i_data,
    input  logic i_valid,
    output logic o_ready,
    input  logic i_last,
    output logic [DW-1:0] o_data,
    output logic o_valid,
    input  logic i_ready,
    output logic o_last,
    // UART
    output logic txd
);

logic [IW-1:0] cobs_odata;
logic cobs_valid, cobs_last, uart_ready;
logic tx_busy;

cobs_encode cobs_encode_inst (
    .clk(clk),
    .rst(rst),
    .i_data(i_data),
    .i_valid(i_valid),
    .o_ready(o_ready),
    .i_last(i_last),
    .o_data(cobs_odata),
    .o_valid(cobs_valid),
    .i_ready(uart_ready),
    .o_last(cobs_last)
);

uart_tx #(
    .DATA_WIDTH(8),
    .PRESCALE(26)
) uart_tx_inst (
    .clk(clk),
    .rst(rst),
    // axi input
    .tdata(cobs_odata),
    .tvalid(cobs_valid),
    .tready(uart_ready),
    // output
    .txd(txd),
    // status
    .busy(tx_busy)
);

endmodule
