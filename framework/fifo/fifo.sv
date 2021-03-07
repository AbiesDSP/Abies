`default_nettype none

module fifo (
    input wire rst, // Optional?
    input wire clk,             // Write clock
    input wire i_wr,            // Write enable
    input wire [DW-1:0] i_wdata,
    output reg o_wfull,
    // input wire rclk,            // Read clock
    input wire i_rd,            // Read enable
    output wire [DW-1:0] o_rdata,
    output reg o_rempty         // This is *almost* empty. If N=4, o_rempty will be 0 if there are at least 2 elements in the buffer.
);

// For testing..
wire rclk;
assign rclk = clk;

parameter DW = 24;
parameter DEPTH = 4;
parameter ALMOST_FULL = 1;
parameter ALMOST_EMPTY = 1;

// Address width.
parameter AW = $clog2(DEPTH);

reg [DW-1:0] ram [DEPTH-1:0];
reg [DW-1:0] ram_data = 0;
/*  "Cummings FIFO" http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
    Gray-code for 4 deep fifo. One extra bit for full/empty detection
    000
    001
    011
    010
    --- Invert gray[N-2] to get bram address.
    110 -> 100
    111 -> 101
    101 -> 111
    100 -> 110
*/
reg [AW:0] rd_ctr, wr_ctr;
wire [AW:0] rd_gray, wr_gray;
wire [AW-1:0] wr_addr, rd_addr;

initial rd_ctr = 0;
initial wr_ctr = 0;

// Convert address counter to gray code.
assign rd_gray = rd_ctr ^ (rd_ctr >> 1);
// Convert N gray code to N-1 gray code. Buffer full detection with proper addressing.
assign rd_addr = rd_gray[AW] ? {~rd_gray[AW-1],rd_gray[AW-2:0]} : rd_gray[AW-1:0];
assign o_rdata = ram_data;
assign wr_gray = wr_ctr ^ (wr_ctr >> 1);
assign wr_addr = wr_gray[AW] ? {~wr_gray[AW-1],wr_gray[AW-2:0]} : wr_gray[AW-1:0];

// Use diff if either flag is set.
generate
    reg [AW:0] diff;
    if (ALMOST_FULL | ALMOST_EMPTY) begin
        always @(*)
            if (wr_ctr > rd_ctr)
                diff = wr_ctr - rd_ctr;
            else if (wr_ctr != 0)
                diff = (((DEPTH<<1)-rd_ctr) + wr_ctr);
            else
                diff = 0;
    end
endgenerate

// Full flag.
generate
    if (ALMOST_FULL) begin
        always @(posedge clk)
            if (diff > (DEPTH>>1))
                o_wfull <= 1;
            else
                o_wfull <= 0;
    end else begin
        always @(posedge clk)
            if ({~wr_ctr[AW],wr_ctr[AW-1:0]} == rd_ctr)
                o_wfull <= 1;
            else
                o_wfull <= 0;
    end

endgenerate
// Empty flag
generate
    if (ALMOST_EMPTY) begin
        always @(posedge rclk)
            if (diff < (DEPTH>>1))
                o_rempty <= 1;
            else
                o_rempty <= 0;
    end else begin
        always @(posedge rclk)
            if (wr_ctr == rd_ctr)
                o_rempty <= 1;
            else
                o_rempty <= 0;
    end
endgenerate

// Infer a dual port BRAM. Following Vivado language template.
// Initialize ram to 0. Not necessary. Only for cleaner simulation.
integer i;
generate
    initial
        for (i = 0; i < DEPTH; i = i + 1)
            ram[i] = 0;
endgenerate
// Write port
always @(posedge clk)
    if (i_wr)
        ram[wr_addr] <= i_wdata;

// Read port
always @(posedge rclk)
    if (i_rd)
        ram_data <= ram[rd_addr];

// Write port controller
always @(posedge clk)
    // Allow overrun? What happens if we do?
    if (i_wr)
        wr_ctr <= wr_ctr + 1;   // Updating the counter updates the write address.

// Read port controller
always @(posedge rclk)
    if (i_rd)
        rd_ctr <= rd_ctr + 1;

endmodule
