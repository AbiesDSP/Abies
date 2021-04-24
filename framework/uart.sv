// The original license is preserved, as required.
/*
Copyright (c) 2014-2017 Alex Forencich
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

module uart #(
    parameter DATA_WIDTH = 8,
    parameter PRESCALE = 10
) (
    input  logic clk,
    input  logic rst,
    // AXI Input
    input  logic [DATA_WIDTH-1:0] s_axis_tdata,
    input  logic s_axis_tvalid,
    output logic s_axis_tready,
    // AXI Output
    output logic [DATA_WIDTH-1:0]  m_axis_tdata,
    output logic m_axis_tvalid,
    input  logic m_axis_tready,
    // UART
    input logic rxd,
    output logic txd,
    // Status
    output logic tx_busy,
    output logic rx_busy,
    output logic rx_overrun_error,
    output logic rx_frame_error
);

uart_tx #(
    .DATA_WIDTH(DATA_WIDTH),
    .PRESCALE(PRESCALE)
) uart_tx_inst (
    .clk(clk),
    .rst(rst),
    // axi input
    .tdata(s_axis_tdata),
    .tvalid(s_axis_tvalid),
    .tready(s_axis_tready),
    // output
    .txd(txd),
    // status
    .busy(tx_busy)
);

uart_rx #(
    .DATA_WIDTH(DATA_WIDTH),
    .PRESCALE(PRESCALE)
) uart_rx_inst (
    .clk(clk),
    .rst(rst),
    // axi output
    .tdata(m_axis_tdata),
    .tvalid(m_axis_tvalid),
    .tready(m_axis_tready),
    // input
    .rxd(rxd),
    // status
    .busy(rx_busy),
    .overrun_error(rx_overrun_error),
    .frame_error(rx_frame_error)
);

endmodule
