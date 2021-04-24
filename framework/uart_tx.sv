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
module uart_tx #(
    parameter DATA_WIDTH = 8,
    parameter PRESCALE = 500
) (
    input  logic clk,
    input  logic rst,
    // AXI Input
    input  logic [DATA_WIDTH-1:0] tdata,
    input  logic tvalid,
    output logic tready,
    // UART
    output logic txd,
    // Status
    output logic busy
);

logic tready_reg = 0;

logic txd_reg = 1;

logic busy_reg = 0;

logic [DATA_WIDTH:0] data_reg = 0;
logic [18:0] prescale_reg = 0;
logic [3:0] bit_cnt = 0;

assign tready = tready_reg;
assign txd = txd_reg;

assign busy = busy_reg;

always @(posedge clk) begin
    if (rst) begin
        tready_reg <= 0;
        txd_reg <= 1;
        prescale_reg <= 0;
        bit_cnt <= 0;
        busy_reg <= 0;
    end else begin
        if (prescale_reg > 0) begin
            tready_reg <= 0;
            prescale_reg <= prescale_reg - 1;
        end else if (bit_cnt == 0) begin
            tready_reg <= 1;
            busy_reg <= 0;

            if (tvalid) begin
                tready_reg <= !tready_reg;
                prescale_reg <= (PRESCALE << 3)-1;
                bit_cnt <= DATA_WIDTH+1;
                data_reg <= {1'b1, tdata};
                txd_reg <= 0;
                busy_reg <= 1;
            end
        end else begin
            if (bit_cnt > 1) begin
                bit_cnt <= bit_cnt - 1;
                prescale_reg <= (PRESCALE << 3)-1;
                {data_reg, txd_reg} <= {1'b0, data_reg};
            end else if (bit_cnt == 1) begin
                bit_cnt <= bit_cnt - 1;
                prescale_reg <= (PRESCALE << 3);
                txd_reg <= 1;
            end
        end
    end
end

endmodule
