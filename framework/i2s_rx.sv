module i2s_rx #(
    parameter DW = 24
) (
    input logic clk,
    input logic rst,
    output logic [DW-1:0] ldata,
    output logic [DW-1:0] rdata,
    output logic valid,
    input logic sclk,
    input logic lrclk,
    input logic sdi
);

// localparam SDCW = $clog2(DW+1);
localparam SDCW = 7;

logic sclk_prev = 0, lrclk_prev = 1;
logic ch = 0, done = 0;
logic [SDCW-1:0] sd_ctr = 0;
logic [DW-1:0] sd_shift = 0;

always @(posedge clk) begin
    done <= 0;
    valid <= 0;
    if (!lrclk & lrclk_prev)
        ch <= 0;
    if (lrclk & !lrclk_prev)
        ch <= 1;
    // Reset counter 
    if (lrclk ^ lrclk_prev) begin
        sd_ctr <= 0;
    // Sample on rising edge.
    end else if (sclk & !sclk_prev) begin
        sd_ctr <= sd_ctr + 1;
        sd_shift <= {sd_shift[DW-2:0], sdi};
        // Last bit.
        if (sd_ctr == DW) begin
            done <= 1;
        end
    end

    if (done) begin
        if (!ch)
            ldata <= sd_shift;
        else begin
            rdata <= sd_shift;
            valid <= 1;
        end
    end
end

always_ff @(posedge clk) begin
    sclk_prev <= sclk;
    lrclk_prev <= lrclk;
end

endmodule
