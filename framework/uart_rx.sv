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

module uart_rx #(
    parameter DATA_WIDTH = 8,
    parameter PRESCALE = 500
) (
    input  logic clk,
    input  logic rst,
    // AXI Output
    output logic [DATA_WIDTH-1:0] tdata,
    output logic tvalid,
    input  logic tready,
    // UART
    input  logic rxd,
    // Status
    output logic busy,
    output logic overrun_error,
    output logic frame_error
);

logic [DATA_WIDTH-1:0] tdata_reg = 0;
logic tvalid_reg = 0;

logic rxd_reg = 1;

logic busy_reg = 0;
logic overrun_error_reg = 0;
logic frame_error_reg = 0;

logic [DATA_WIDTH-1:0] data_reg = 0;
logic [18:0] prescale_reg = 0;
logic [3:0] bit_cnt = 0;

assign tdata = tdata_reg;
assign tvalid = tvalid_reg;

assign busy = busy_reg;
assign overrun_error = overrun_error_reg;
assign frame_error = frame_error_reg;

always @(posedge clk) begin
    if (rst) begin
        tdata_reg <= 0;
        tvalid_reg <= 0;
        rxd_reg <= 1;
        prescale_reg <= 0;
        bit_cnt <= 0;
        busy_reg <= 0;
        overrun_error_reg <= 0;
        frame_error_reg <= 0;
    end else begin
        rxd_reg <= rxd;
        overrun_error_reg <= 0;
        frame_error_reg <= 0;

        if (tvalid && tready) begin
            tvalid_reg <= 0;
        end

        if (prescale_reg > 0) begin
            prescale_reg <= prescale_reg - 1;
        end else if (bit_cnt > 0) begin
            if (bit_cnt > DATA_WIDTH+1) begin
                if (!rxd_reg) begin
                    bit_cnt <= bit_cnt - 1;
                    prescale_reg <= (PRESCALE << 3)-1;
                end else begin
                    bit_cnt <= 0;
                    prescale_reg <= 0;
                end
            end else if (bit_cnt > 1) begin
                bit_cnt <= bit_cnt - 1;
                prescale_reg <= (PRESCALE << 3)-1;
                data_reg <= {rxd_reg, data_reg[DATA_WIDTH-1:1]};
            end else if (bit_cnt == 1) begin
                bit_cnt <= bit_cnt - 1;
                if (rxd_reg) begin
                    tdata_reg <= data_reg;
                    tvalid_reg <= 1;
                    overrun_error_reg <= tvalid_reg;
                end else begin
                    frame_error_reg <= 1;
                end
            end
        end else begin
            busy_reg <= 0;
            if (!rxd_reg) begin
                prescale_reg <= (PRESCALE << 2)-2;
                bit_cnt <= DATA_WIDTH+2;
                data_reg <= 0;
                busy_reg <= 1;
            end
        end
    end
end

endmodule